class Api::UsersController < Api::ApiController

  # merge local data with account data
  def merge
    notes = params[:notes]
    notes.each do |s|
      note_params = s.permit(:name, :content)
      note = current_user.notes.new(note_params)
      tag_name = s[:tag_name]
      if tag_name
        tag = current_user.tags.where(:name => tag_name).first
        if !tag
          tag = current_user.tags.create({:name => tag_name})
        end
      end
      note.tag = tag
      note.save
    end
  end

  def current
    render :json => current_user
  end

  def update
    current_user.update(u_params)
    render :json => current_user
  end

  private
  def u_params
    params.permit()
  end
end
