require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  get "up" => "rails/health#show", as: :rails_health_check

  post 'cart', to: 'carts#add_product'
  get 'cart', to: 'carts#show'

  root "rails/health#show"
end
