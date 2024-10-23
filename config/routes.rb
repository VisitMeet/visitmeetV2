Rails.application.routes.draw do
  resources :tags
  # config/routes.rb
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'profile/:username', to: 'profiles#show', as: 'profile'

  # Defines the root path route ("/")
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root "home#index"
end
