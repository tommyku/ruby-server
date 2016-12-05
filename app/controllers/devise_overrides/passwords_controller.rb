module DeviseOverrides
  class PasswordsController < DeviseTokenAuth::PasswordsController

    def edit
      super do # TODO there is minor bug too - block does not pass resource
        # TODO build url correctly when it already has some params (I did not need it in my case)
        params[:redirect_url] += "?reset_password_token=#{@resource.reset_password_token}&email=#{@resource.email}"
      end
    end

    protected

    def resource_update_method
      @resource.allow_password_change = @resource.reset_password_token.present? && resource_params[:reset_password_token] == @resource.reset_password_token
      super
    end

  end
end
