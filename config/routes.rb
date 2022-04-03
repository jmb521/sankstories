Rails.application.routes.draw do
  resources :orders
  resources :books
  resources :addresses
  resources :purchasers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
