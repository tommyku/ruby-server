class PresentationsController < ApplicationController

  include MarkdownHelper

  respond_to :html, :json

  def not_found(message = 'not_found')
    render json: {error: message}, status: :not_found
  end

  def show
    if !params[:presentation_name]
      not_found
      return
    end

    if Rails.configuration.x.single_user_mode
      @item = Item.find_by_presentation_name(params[:presentation_name])
    else
      user = User.find_by_username(params[:username])
      @item = user.items.find_by_presentation_name(params[:presentation_name])
    end

    type = @item.content_type

    case type
    when "Note"
      @notes = [@item]
    when "Group"
      @group = @item
      note_ids = @item.value_for_content_key("references").select{|e| e.content_type == "Note"}.map { |e| e.uuid }
      @notes = Item.where("uuid IN ?", note_ids)
    end

    @notes.each do |note|
      note.rendered_content = MarkdownHelper.rendered_content_for_text(note.value_for_content_key("text"))
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

end
