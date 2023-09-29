Rails.application.routes.draw do
  resources :users
  resources :sessions, only: [:create]
  
  get '/login', to: 'sessions#new', as: :login
  delete '/logout', to: 'sessions#destroy', as: :logout

  root 'users#show'
end
