Rails.application.routes.draw do
  resources :users, except: [:create]
  resources :sessions, only: [:create]

  post '/signup', to: 'users#create', as: :signup
  get '/login', to: 'sessions#new', as: :login
  delete '/logout', to: 'sessions#destroy', as: :logout

  root 'welcome#index'
end
