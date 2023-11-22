Rails.application.routes.draw do
  get 'about', to: 'pages#about'
  get 'refresh_data', to: 'pages#refresh_data'
  get 'home', to: 'pages#home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "pages#index"
end
