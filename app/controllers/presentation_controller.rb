class PresentationController < ApplicationController

  def not_found(message = 'not_found')
    render json: {error: message}, status: :not_found
  end

  def show

    @notes = []

    if !params[:root_presentation_path]
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
      note.rendered_content = markdown.render(note.content)
    end

    if @notes.length > 0
      @base_note = @notes.first
      @desc = @base_note.content[0,200]
      @title = @base_note.name
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

end
