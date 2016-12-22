class Users::SessionsController < Devise::SessionsController

  respond_to :json

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    render json: { user: resource, token: resource.jwt, items: resource.items }
  end

end
