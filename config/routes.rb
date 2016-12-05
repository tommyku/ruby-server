Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    passwords: 'devise_overrides/passwords'
  }

  resources :users do
    member do
      post :merge
      post :enable_encryption
      post :disable_encryption
      post :set_username
    end

    resources :notes do
      member do
        post :share
        post :unshare
      end

      collection do
        put :batch_update
      end
    end

    resources :groups do
      member do
        post :share
        post :unshare
      end
    end

  end

  resources :notes do
    collection do
      post :share
      post :unshare
    end
  end

  resources :groups do
  end

  get 'sitemap.xml', :to => 'sitemap#index', :defaults => { :format => 'xml' }

  get ':root_presentation_path', :to => 'presentation#show'
  get ':root_presentation_path/:secondary_presentation_path', :to => 'presentation#show'

  get '*path' => 'application#frontend'

  if ENV['ROOT_PRESENTATION_PATH']
    root :to => "presentation#root"
  elsif ENV['ROOT_REDIRECT']
    root :to => redirect("#{ENV['ROOT_REDIRECT']}", :status => 302)
  end
end
