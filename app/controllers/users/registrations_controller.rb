class Users::RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :json

  # POST /resource
  def create
    build_resource(sign_up_params)

   resource.save
   yield resource if block_given?
   if resource.persisted?
     if resource.active_for_authentication?
       set_flash_message! :notice, :signed_up
       sign_up(resource_name, resource)
       render json: { user: resource, token: resource.jwt }
     else
       set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
       expire_data_after_sign_in!
       render json: { user: resource, token: resource.jwt }
     end
   else
     clean_up_passwords resource
     set_minimum_password_length
     respond_with resource
   end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:pw_func, :pw_alg, :pw_cost, :pw_key_size, :pw_nonce])
  end

end
