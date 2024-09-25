Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  namespace :api do
    namespace :v1 do
      get "user_sessions/new"
      get "user_sessions/create"
      get "user_sessions/destroy"
      get "sessions/new"
      get "sessions/create"
      get "sessions/destroy"
      resources :products do
        collection do
          get :search
        end
      end
      resources :categories

      resources :users, only: [:new, :create, :sign_in]
      resources :user_sessions, only: [:create, :destroy, :new]
      get 'home', to: 'home#index'
      post 'home', to: 'home#index'
      get 'login', to: 'users#login'
      post 'login', to: 'users#sign_in'
      delete 'logout', to: 'users#logout'
      resources :products do
        resources :orders, only: [:index, :new, :create, :show, :edit, :update] do
          post 'notify_me', on: :member
        end
      end

      resources :orders, only: [:index, :new, :create, :show, :edit, :update]
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  get "categories/index"

  root "products#index"
  # get "/articles", to: "articles#index"
  # get "/articles/:id", to: "articles#show"
  # resources :categories
  # resources :user, only: [:index, :new, :create]
  # get 'login', to: 'users#login'
  # post 'login', to: 'users#authenticate'
  # resources :products do
  #   resources :orders, only: [:index, :new, :create, :show, :edit, :update]
  # end
  #
  # resources :orders, only: [:index, :new, :create, :show, :edit, :update]

end
