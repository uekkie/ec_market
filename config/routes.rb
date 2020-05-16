Rails.application.routes.draw do
  devise_for :users

  root to: "items#index"
  resources :items, only: %i[index show]

  resource :cart, only: [:show]
  post '/add_item' => 'carts#add_item'
  post '/update_item' => 'carts#update_item'
  delete '/delete_item' => 'carts#delete_item'

end
