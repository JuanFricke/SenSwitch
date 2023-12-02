Rails.application.routes.draw do
  devise_for :users
  get 'about', to: 'pages#about'
  get 'refresh_data', to: 'pages#refresh_data'
  get 'test', to: 'pages#test'
  get 'sobre', to: 'pages#sobre'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "pages#home"
end
