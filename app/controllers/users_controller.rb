class UsersController < ApiController

  skip_before_action :authenticate_user!, :only => [:authparams]

  before_action {
    @user = current_user
    # if !@user
    #   render_unauthorized
    # end
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

  def authparams
    email = params[:email]
    user = User.find_by_email(email)
    pw_salt = user ? Digest::SHA1.hexdigest(email + "SN" + user.pw_nonce) : Digest::SHA1.hexdigest(email + "SN" + ENV["SALT_PSEUDO_NONCE"])
    pw_cost = user ? user.pw_cost : 5000
    pw_alg = user ? user.pw_alg : "sha512"
    pw_key_size = user ? user.pw_key_size : 512
    pw_func = user ? user.pw_func : "pbkdf2"
    render :json => {:pw_func => pw_func, :pw_alg => pw_alg, :pw_salt => pw_salt, :pw_cost => pw_cost, :pw_key_size => pw_key_size}
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
