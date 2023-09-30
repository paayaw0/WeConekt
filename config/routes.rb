Rails.application.routes.draw do
  resources :users, except: [:create]
  resources :sessions, only: [:new]

  post '/signup', to: 'users#create', as: :signup
  post '/login', to: 'sessions#create', as: :login
  delete '/logout', to: 'sessions#destroy', as: :logout

  root 'welcome#index'
end
