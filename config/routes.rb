Rails.application.routes.draw do

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
      post :set_username
    end

    resources :items do
      resources :presentations
      resources :references
      collection do
        put :batch_update
      end
    end

  end

  post 'import' => "users#import"

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
