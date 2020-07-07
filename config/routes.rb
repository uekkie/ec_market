Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'

  }

  devise_for :merchants, controllers: {
    registrations: 'merchants/registrations',
    sessions: 'merchants/sessions'
  }

  root to: 'posts#index'
  resources :items, only: %i[index show]

  namespace :admins do
    resources :items do
      member do
        post :up_position
        post :down_position
      end
    end
    resources :coupons
  end

  resource :cart, only: [:show]
  post '/add_item' => 'carts#add_item'
  post '/update_item' => 'carts#update_item'
  delete '/delete_item' => 'carts#delete_item'

  resources :orders, only: %i[index show new create]

  resources :posts, only: %i[index]
  resources :posts, module: :users, only: %i[new]

  namespace :users do
    resources :coupons
    resources :points, only: %i[index edit update]
    resources :order_statuses, only: :update
  end

  resources :users do
    get :profile, action: :profile, on: :collection
    resources :posts, module: :users, only: %i[create edit update destroy]
    resources :posts, only: %i[show] do
      resources :comments, module: :posts, only: %i[create destroy]
      resources :goods, only: %i[create destroy]
    end
    resources :charges, module: :users, only: %i[new create]
  end

  namespace :admins do
    resources :merchants
  end

  namespace :merchants do
    resources :items
  end
  resources :merchants, only: %i[show update] do
    get :profile, action: :profile, on: :collection
  end

  mount LetterOpenerWeb::Engine, at: '/lo' if Rails.env.development?
end
