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
      group_name = s[:group_name]
      if group_name
        group = @user.groups.where(:name => group_name).first
        if !group
          group = @user.groups.create({:name => group_name})
        end
      end
      note.group = group
      note.save
    end
  end

  def current
    render :json => @user, include: [
      :presentation,
      {:groups => {:include => [:presentation]}},
      {:notes => {:include => [:presentation]}}
    ]
  end

  def update
    @user.update(u_params)
    render :json => @user
  end

  def enable_encryption
    @user.local_encryption_enabled = true
    @user.save
    render :json => @user
  end

  def disable_encryption
    @user.local_encryption_enabled = false
    @user.save
    render :json => @user
  end

  def set_username
    if !@user.presentation
      @user.presentation = @user.owned_presentations.new({:presentable => @user})
    end
    @user.presentation.root_path = params[:username]
    @user.presentation.enabled = false
    @user.presentation.save
    render :json => @user.presentation
  end

  private
  def u_params
    params.permit(:username)
  end
end
