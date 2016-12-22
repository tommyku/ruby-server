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
    end

    resources :items, param: :uuid
  end

  resources :items, param: :uuid

  get 'auth/params' => "users#authparams"

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
