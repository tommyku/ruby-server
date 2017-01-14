Rails.application.routes.draw do

  namespace :api, defaults: {format: :json} do

    post "auth/sign_in" => "auth#sign_in"
    post "auth" => "auth#register"

    get 'auth/params' => "auth#auth_params"

    resources :users do
      collection do
        get :current
      end

      member do
        post :merge
      end
    end

    resources :items, param: :uuid do
      collection do
        post :sync
      end
    end
  end

  get '*path' => 'application#frontend'

  root to: "home#index"
end
