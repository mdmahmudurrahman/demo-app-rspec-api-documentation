Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts do
        resources :comments, only: [:create, :destroy]
      end

      resources :users, only: [:create, :index]

      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'

      namespace :admin do
        resources :authors
        resources :books
      end
    end
  end
end
