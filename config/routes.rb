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

  
  resource :profile, only: [:show, :update] do
    patch :update_picture
    post :add_tag
    delete :remove_tag
    post :add_photo
    delete :remove_photo
  end

  resources :users, only: [:show] do
    member do
      post :follow
      delete :unfollow
    end
  end

  # Tags
  resources :tags
  get 'tags/autocomplete', to: 'tags#autocomplete'

  # Search and results
  get 'results', to: 'results#index'
  get 'search', to: 'results#index', as: 'search_results'
  get 'search_suggestions', to: 'search_suggestions#index'

  # Offerings with nested bookings
  resources :offerings do
    resources :bookings, only: [:new, :create]
    resources :reviews, only: [:create, :destroy]
  end

  # Bookings management
  resources :bookings, except: [:new, :create] do
    collection do
      get :hosted
    end
    member do
      patch :accept
      patch :decline
      patch :cancel
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Conversations and Messages
  resources :conversations do
    resources :messages
  end
end
