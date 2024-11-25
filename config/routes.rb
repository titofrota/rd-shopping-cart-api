require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  get "up" => "rails/health#show", as: :rails_health_check

  resource :cart do
    post '/', to: 'carts#add_product'
    get '/', to: 'carts#show'
    post '/add_item', to: 'carts#add_item'
  end

  root "rails/health#show"
end
