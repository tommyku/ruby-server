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

      resources :items, param: :uuid do
        collection do
          post :sync
        end
      end
    end

    # resources :items, param: :uuid
  end

  get 'sitemap.xml', :to => 'sitemap#index', :defaults => { :format => 'xml' }

  get ':presentation_name', :to => 'presentations#show'
  get ':username/:presentation_name', :to => 'presentations#show'

  get '*path' => 'application#frontend'

  if ENV['ROOT_PRESENTATION_NAME']
    root :to => "presentations#root"
  elsif ENV['ROOT_REDIRECT']
    root :to => redirect("#{ENV['ROOT_REDIRECT']}", :status => 302)
  end

  root to: "home#index"
end
