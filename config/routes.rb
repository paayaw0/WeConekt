Rails.application.routes.draw do
  resources :users, except: [:new]
  resources :sessions, only: [:create]

  get '/signup', to: 'users#new', as: :signup
  get '/login', to: 'sessions#new', as: :login
  delete '/logout', to: 'sessions#destroy', as: :logout

  root 'welcome#index'
end
