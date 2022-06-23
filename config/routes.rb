Rails.application.routes.draw do
  # get '/orders/new/:isbn', to: "orders#new"
  resources :orders
  resources :books
  resources :addresses
  resources :purchasers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "orders#index"
  post '/payment', to: "payments#payment"
  post '/calculate_shipping', to: "shipping#calculate_shipping"
  # get '/oauth2/callback', to: "orders#callback"
end
