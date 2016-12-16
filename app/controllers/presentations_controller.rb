class PresentationsController < ApplicationController

  respond_to :html, :json

  before_action only: [:create, :update, :destroy] {
    if params[:uuid]
      @presentation = current_user.owned_presentations.find(params[:uuid])
    end

    @item = current_user.items.find(params[:item_uuid])
  }

  def not_found(message = 'not_found')
    render json: {error: message}, status: :not_found
  end

  def show
    @items = []

    if !params[:root_presentation_path]
      not_found
      return
    end

    if Rails.configuration.x.single_user_mode
      @presentation = root_presentation = Presentation.find_by_root_path(params[:root_presentation_path])
      if params[:secondary_presentation_path]
        @presentation = @presentation.owner.owned_presentations.find_by_relative_path(params[:secondary_presentation_path])
      end
    else
      user = User.find_by_username(params[:root_presentation_path])
      @presentation = user.owned_presentations.find_by_relative_path(params[:secondary_presentation_path])
    end


    if !@presentation
      not_found
      return
    end

    type = @presentation.item.content_type

    case type
    when "Note"
      @notes = [@presentation.item]
    when "Group"
      @group = @presentation.item
      @notes = @presentation.item.references.where(:content_type => "Note")
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
      note.rendered_content = markdown.render(note.value_for_content_key("text"))
    end

    if @notes.length > 0
      @base_note = @notes.first
      @desc = @base_note.value_for_content_key("text")[0,200]
      @title = @base_note.value_for_content_key("title")
    elsif @group
      @title = "#{@group.value_for_content_key('name')} — #{root_presentation.root_path}"
    end
  end

  def root
    params["root_presentation_path"] = ENV['ROOT_PRESENTATION_PATH']
    self.show
    render :template => "presentation/show"
  end

  def create

    if !@item.presentation
      if current_user
        @item.presentation = current_user.owned_presentations.new({:item => @item})
      else
        @item.presentation = Presentation.new({:item => @item})
      end
    end

    if Rails.configuration.x.single_user_mode
      if @item.content_type == "Note"
        @item.presentation.set_root_path_from_name(@item.value_for_content_key("title")) unless @item.presentation.root_path
      else
        @item.presentation.set_root_path_from_name(@item.value_for_content_key("name")) unless @item.presentation.root_path
      end
    else
      if !current_user.username
        render :json => {:errors => ["Username is not set."]}, :status => 500
        return
      end
      @item.presentation.root_path = current_user.username
      if @item.content_type == "Note"
        @item.presentation.relative_path = @item.presentation.slug_for_property_and_name(:relative_path, @item.value_for_content_key("title")) unless @item.presentation.relative_path
      else
        @item.presentation.relative_path = @item.name.downcase unless @item.presentation.relative_path
      end
    end

    @item.presentation.save

    if @item.save
      render :json => @item.presentation
    else
      not_valid @item
    end
  end

  def update
    @presentation.update(params.permit(:relative_path))
    render :json => @presentation
  end

  def destroy
    @presentation.destroy
  end

end
