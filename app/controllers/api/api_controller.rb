class Api::ApiController < ApplicationController
  respond_to :json
  attr_accessor :current_user

  before_action :authenticate_user

  before_action {
    request.env['HTTP_ACCEPT_ENCODING'] = 'gzip'
  }

  protected

  def authenticate_user
    if !request.headers['Authorization'].present?
      render_invalid_auth
      return
    end

    strategy, token = request.headers['Authorization'].split(' ')
    if (strategy || '').downcase != 'bearer'
      render_invalid_auth
      return
    end

    claims = StandardFile::JwtHelper.decode(token) rescue nil
    self.current_user = User.find_by_uuid claims['user_uuid']
  end

  def not_found(message = 'not_found')
    render json: {error: {:message => message, :tag => "not-found"}}, status: :not_found
  end

  def render_invalid_auth
    render :json => {:error => {:tag => "invalid-auth", :message => "Invalid login credentials."}}, :status => 401
  end

end
