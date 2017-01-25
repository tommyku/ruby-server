Rails.application.routes.draw do

  # forward non-namespaced routes to api namespace
  post "items/sync" => "api/items#sync"
  get 'auth/params' => "api/auth#auth_params"
  post "auth/sign_in" => "api/auth#sign_in"
  post "auth" => "api/auth#register"

  namespace :api, defaults: {format: :json} do
    get 'auth/params' => "auth#auth_params"
    post "auth/sign_in" => "auth#sign_in"
    post "auth" => "auth#register"

    post "items/sync" => "items#sync"
  end

end
