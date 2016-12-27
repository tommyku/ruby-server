class CustomFailureApp < Devise::FailureApp
  def respond
    if request.format == :json
      json_failure
    else
      super
    end
  end

  def json_failure
    puts warden.message || warden_options[:message]
    puts i18n_message(:invalid)
    puts self.status
    # self.status = 401
    # self.content_type = 'application/json'
    # self.response_body = {:status => 401, :message => i18n_message(:invalid)}.to_json
  end
end
