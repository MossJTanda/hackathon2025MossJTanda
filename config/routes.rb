Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "sessions#new"

  # Home/Dashboard
  get "home", to: "home#index", as: :home
  get "logged_in", to: "home#index"

  # Session routes (singular resource)
  get "session/new", to: "sessions#new", as: :new_session
  post "session", to: "sessions#create", as: :session
  delete "session", to: "sessions#destroy"

  # User routes (web)
  get "users/new", to: "users#new", as: :new_user
  post "users", to: "users#create", as: :users
  get "users/:id", to: "users#show", as: :user
  get "profile", to: "users#profile", as: :profile

  # Friends and Friend Requests
  resources :friends, only: [:index, :new, :destroy]
  resources :friend_requests, only: [:index, :create, :destroy] do
    member do
      post :accept
      post :decline
    end
  end

  # Secret Santa Events
  resources :events do
    member do
      post :generate_assignments
      post :reset_assignments
    end

    # Add participant selection page
    get 'add_participant', to: 'event_participants#new', as: 'add_participant'
    resources :participants, only: [:create, :destroy], controller: 'event_participants'

    # Block management for a specific participant
    get 'blocks/:user_id/edit', to: 'event_blocks#edit', as: 'edit_participant_blocks'
    post 'blocks/:user_id/update', to: 'event_blocks#update', as: 'update_participant_blocks'
  end

  # API Routes
  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'auth#login'
      post 'auth/refresh', to: 'auth#refresh'

      # API User routes
      # Expanded syntax instead of resources :users, only: [:show, :create, :update]
      get 'users/:id', to: 'users#show'
      post 'users', to: 'users#create'
      patch 'users/:id', to: 'users#update'
      put 'users/:id', to: 'users#update'
    end
  end
end
