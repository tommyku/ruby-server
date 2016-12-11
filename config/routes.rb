Rails.application.routes.draw do

  # mount_devise_token_auth_for 'User', at: 'auth', controllers: {
  #   passwords: 'devise_overrides/passwords'
  # }

  devise_for :users, path: 'auth', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }


  resources :users do
    collection do
      get :current
    end
    member do
      post :merge
      post :enable_encryption
      post :disable_encryption
      post :set_username
    end

    resources :notes do
      resources :presentations
      # member do
      #   post :share
      #   post :unshare
      # end

      collection do
        put :batch_update
      end
    end

    resources :groups do
      resources :presentations
      # member do
      #   post :share
      #   post :unshare
      # end
    end

  end

  resources :notes do
    # collection do
    #   post :share
    #   post :unshare
    # end
  end

  resources :groups do
  end

  get 'sitemap.xml', :to => 'sitemap#index', :defaults => { :format => 'xml' }

  get ':root_presentation_path', :to => 'presentations#show'
  get ':root_presentation_path/:secondary_presentation_path', :to => 'presentations#show'

  get '*path' => 'application#frontend'

  if ENV['ROOT_PRESENTATION_PATH']
    root :to => "presentations#root"
  elsif ENV['ROOT_REDIRECT']
    root :to => redirect("#{ENV['ROOT_REDIRECT']}", :status => 302)
  end

  root to: "home#index"
end
