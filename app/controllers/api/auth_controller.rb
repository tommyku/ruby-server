class Api::AuthController < Api::ApiController

  skip_before_action :authenticate_user

  def sign_in
    user = User.find_by_email(params[:email])
    if user and User.test_password(params[:password], user.encrypted_password)
      render json: { user: user, token: user.jwt, items: user.items }
    else
      render :json => {:error => {:message => "Invalid email or password.", :status => 401}}, :status => 401
    end
  end

  def register
    user = User.find_by_email(params[:email])
    if user
      render :json => {:error => {:message => "Unable to register.", :status => 401}}, :status => 401
    else
      user = User.new(:email => params[:email], :encrypted_password => User.hash_password(params[:password]))
      user.update!(registration_params)
      render json: { user: user, token: user.jwt }
    end
  end

  def auth_params
    email = params[:email]
    user = User.find_by_email(email)
    pw_salt = user ? Digest::SHA1.hexdigest(email + "SN" + user.pw_nonce) : Digest::SHA1.hexdigest(email + "SN" + ENV["SALT_PSEUDO_NONCE"])
    pw_cost = user ? user.pw_cost : 5000
    pw_alg = user ? user.pw_alg : "sha512"
    pw_key_size = user ? user.pw_key_size : 512
    pw_func = user ? user.pw_func : "pbkdf2"
    render :json => {:pw_func => pw_func, :pw_alg => pw_alg, :pw_salt => pw_salt, :pw_cost => pw_cost, :pw_key_size => pw_key_size}
  end

  def registration_params
    params.permit(:pw_func, :pw_alg, :pw_cost, :pw_key_size, :pw_nonce)
  end

end
