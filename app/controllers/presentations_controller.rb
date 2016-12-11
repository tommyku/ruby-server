class PresentationsController < ApplicationController

  respond_to :html, :json

  before_action only: [:create, :update, :destroy] {
    if params[:id]
      @presentation = current_user.owned_presentations.find(params[:id])
    end
    if params[:note_id]
      @note = current_user.notes.find(params[:note_id])
    elsif params[:group_id]
      @group = current_user.groups.find(params[:group_id])
    end

  }

  def not_found(message = 'not_found')
    render json: {error: message}, status: :not_found
  end

  def show
    @notes = []

    if !params[:root_presentation_path]
      not_found
      return
    end

    @presentation = root_presentation = Presentation.find_by_root_path(params[:root_presentation_path])
    if params[:secondary_presentation_path]
      @presentation = @presentation.owner.owned_presentations.find_by_relative_path(params[:secondary_presentation_path])
    end

    if !@presentation || @presentation.enabled == false
      not_found
      return
    end

    type = @presentation.presentable_type

    case type
    when "Note"
      @notes = [@presentation.presentable]
    when "Group"
      @group = @presentation.presentable
      @notes = @presentation.presentable.notes
    end

    options = {
     filter_html:     true,
     hard_wrap:       true,
     link_attributes: { rel: 'nofollow', target: "_blank" },
     space_after_headers: true,
     fenced_code_blocks: true,
     prettify: true
    }

     extensions = {
       autolink:           true,
       superscript:        true,
       disable_indented_code_blocks: true,
       fenced_code_blocks: true,
       lax_spacing: true
     }

     renderer = Redcarpet::Render::HTML.new(options)
     markdown = Redcarpet::Markdown.new(renderer, extensions)

    @notes.each do |note|
      note.rendered_content = markdown.render(note.text)
    end

    if @notes.length > 0
      @base_note = @notes.first
      @desc = @base_note.text[0,200]
      @title = @base_note.title
    elsif @group
      @title = "#{@group.name} — #{root_presentation.root_path}"
    end
  end

  def root
    params["root_presentation_path"] = ENV['ROOT_PRESENTATION_PATH']
    self.show
    render :template => "presentation/show"
  end

  def includes_for_type(model_type)
    case model_type
    when "Note"

    when "Group"
      return [:notes]
    when "User"

    end
  end

  def create

    resource = @note || @group

    if !resource.presentation
      if current_user
        resource.presentation = current_user.owned_presentations.new({:presentable => resource})
      else
        resource.presentation = Presentation.new({:presentable => resource})
      end
    end

    if Rails.configuration.x.neeto.single_user_mode
      resource.presentation.set_root_path_from_name(@group ? @group.name : @note.title) unless resource.presentation.root_path
    else
      if @note
        @note.presentation.set_random_root_path unless @note.presentation.root_path
      else
        @group.presentation.relative_path = @group.name.downcase unless @group.presentation.relative_path
        @group.presentation.parent_path = current_user.presentation.root_path if current_user.presentation
      end
    end

    resource.presentation.enabled = true
    resource.presentation.save

    if @group
      @group.notes.each do |note|
        note.shared_via_group = true
        note.save!
      end
    end

    if resource.save
      render :json => resource.presentation
    else
      not_valid resource
    end
  end

  def update
    @presentation.update(params.permit(:enabled))
    render :json => @presentation
  end

  def destroy
    @presentation.destroy
  end

end
