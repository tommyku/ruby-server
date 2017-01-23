Rails.application.routes.draw do

  namespace :api, defaults: {format: :json} do
    get 'auth/params' => "auth#auth_params"
    post "auth/sign_in" => "auth#sign_in"
    post "auth" => "auth#register"

    post "items/sync" => "items#sync"
  end

end
