Rails.application.routes.draw do
  devise_for :users

  root to: "items#index"
  resources :items, only: %i[index show]

  namespace :admins do
    resources :items do
      member do
        post :up_position
        post :down_position
      end
    end
  end

  resource :cart, only: [:show]
  post '/add_item' => 'carts#add_item'
  post '/update_item' => 'carts#update_item'
  delete '/delete_item' => 'carts#delete_item'

  resources :orders, only: %i[new create]
end
