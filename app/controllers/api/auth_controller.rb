class Api::AuthController < Api::ApiController

  skip_before_action :authenticate_user, except: [:change_pw]

  before_action {
    @user_manager = StandardFile::UserManager.new(User, ENV['SALT_PSEUDO_NONCE'])
  }

  def sign_in
    result = @user_manager.sign_in(params[:email], params[:password])
    if result[:error]
      render :json => result, :status => 401
    else
      render :json => result
    end
  end

  def register
    result = @user_manager.register(params[:email], params[:password], params)
    if result[:error]
      render :json => result, :status => 401
    else
      render :json => result
    end
  end

  def change_pw
    result = @user_manager.change_pw(current_user, params[:new_password], params)
    if result[:error]
      render :json => result, :status => 401
    else
      render :json => result
    end
  end

  def auth_params
    render :json => @user_manager.auth_params(params[:email])
  end

end
