Rails.application.routes.draw do
  root 'home#index'

  get'cities/:id/forecast/:name/:country/:locationKey', to: 'cities#forecast'

  get'cities/:id/codigo/:name/:country/', to: 'cities#codigo'

  

  resources :cities
  #get '/home', to: 'home#index'

  #syntax get 'ruta'. to: /controller_name/action_name
  #get '/cities', to: 'cities#index'

  #get '/cities/new', to: 'cities#new'

  #get '/cities/:id', to: 'cities#show'

  #get'cities/:id/forecast/:locationKey', to: 'cities#forecast'

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
