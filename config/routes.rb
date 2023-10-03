Rails.application.routes.draw do
  resources :users, except: [:new]
  resources :sessions, only: [:create]

  post '/ping', to: 'pings#ping_user', as: :ping_user
  post '/decline_ping', to: 'pings#decline'
  post '/accept_ping', to: 'pings#accept'
  get '/signup', to: 'users#new', as: :signup
  get '/login', to: 'sessions#new', as: :login
  delete '/logout', to: 'sessions#destroy', as: :logout

  root 'welcome#index'
end
