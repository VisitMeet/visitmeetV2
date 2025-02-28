Rails.application.routes.draw do
  resources :profiles, only: [:show] do
    post 'add_tag', on: :member
  end
  get 'offerings/new'
  get 'offerings/create'
  resources :tags
  # config/routes.rb
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :offerings
end
