Rails.application.routes.draw do
  get 'shared_messages/new'
  resources :users, except: [:new] do
    resources :messages, only: [:create]
  end

  resources :messages, only: %i[edit update destroy]
  get '/delete_message_options/:message_id', to: 'messages#delete_message_options', as: :delete_message_options
  post '/cancel', to: 'messages#cancel'

  resources :shared_messages

  resources :sessions, only: [:create]
  resources :rooms

  post '/leave_room', to: 'rooms#leave'
  post '/join_room', to: 'rooms#join'
  post '/ping', to: 'pings#ping_user', as: :ping_user
  post '/decline_ping', to: 'pings#decline'
  post '/accept_ping', to: 'pings#accept'
  get '/signup', to: 'users#new', as: :signup
  get '/login', to: 'sessions#new', as: :login
  delete '/logout', to: 'sessions#destroy', as: :logout

  root 'sessions#new'
end
