class UsersController < ApiController

  before_action {
    @user = current_user
    if !@user
      render_unauthorized
    end
  }

  # merge local data with account data
  def merge
    notes = params[:notes]
    notes.each do |s|
      note_params = s.permit(:name, :content)
      note = @user.notes.new(note_params)
      tag_name = s[:tag_name]
      if tag_name
        tag = @user.tags.where(:name => tag_name).first
        if !tag
          tag = @user.tags.create({:name => tag_name})
        end
      end
      note.tag = tag
      note.save
    end
  end

  def current
    render :json => @user, include: :items
  end

  def update
    @user.update(u_params)
    render :json => @user
  end

  private
  def u_params
    params.permit(:username)
  end
end
