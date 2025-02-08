require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :products
  resources :carts, path: 'cart', only: %i[index create] do
    patch :add_item, to: 'carts#update', on: :collection
    delete ':product_id', to: 'carts#destroy', on: :collection, as: :remove_items
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "products#index"
end
