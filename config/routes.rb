Rails.application.routes.draw do

  get "dashboard" => "application#dashboard"

  # forward non-namespaced routes to api namespace
  get 'auth/params' => "api/auth#auth_params"
  post "auth/sign_in" => "api/auth#sign_in"
  post "auth" => "api/auth#register"
  post "items/sync" => "api/items#sync"
  delete "items" => "api/items#destroy"

  namespace :api, defaults: {format: :json} do
    get 'auth/params' => "auth#auth_params"
    post "auth/sign_in" => "auth#sign_in"
    post "auth" => "auth#register"
    post "items/sync" => "items#sync"
    delete "items" => "items#destroy"
  end

end
