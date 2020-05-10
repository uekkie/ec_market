Rails.application.routes.draw do
  devise_for :users

  root to: "items#index"

  resources :items, only: %i[index show]

  resources :cart_items, only: %i[create destroy]
end
