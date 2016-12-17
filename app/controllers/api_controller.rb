class ApiController < ApplicationController
  respond_to :json

  before_action :authenticate_user!

  before_action {
    request.env['HTTP_ACCEPT_ENCODING'] = 'gzip'
  }

  protected

  def not_found(message = 'not_found')
    render json: {error: message}, status: :not_found
  end

  def not_valid(entity)
    render json: entity.errors, status: :unprocessable_entity
  end

  def render_unauthorized
    render json: {"errors" => ["Authorized members only."]}, status: :unauthorized
  end

  def param_include
    if params[:include]
      begin
        includes = JSON.parse(params[:include], :symbolize_names => true)
      rescue
        includes = params[:include]
      end
      return includes
    end
  end

end
