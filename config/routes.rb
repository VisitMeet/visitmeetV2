Rails.application.routes.draw do
  # Devise authentication
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  # Root and home
  root "home#index"
  get 'home/index'

  # User profiles
  resources :profiles, only: [:show] do
    member do
      post :add_tag
      delete :remove_tag
    end
  end
  resources :users, only: [:show]

  # Tags
  resources :tags
  get 'tags/autocomplete', to: 'tags#autocomplete'

  # Search and results
  get 'results', to: 'results#index'
  get 'search', to: 'results#index', as: 'search_results'

  # Offerings with nested bookings
  resources :offerings do
    resources :bookings, only: [:new, :create]
  end

  # Bookings management
  resources :bookings, except: [:new, :create] do
    member do
      patch :accept
      patch :decline
      patch :cancel
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
