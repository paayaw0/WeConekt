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

  get '/set_disappearing_messages/:room_id', to: 'room_configurations#set_disappearing_messages',
                                             as: :set_disappearing_messages
  post '/enable_disappearing_messages', to: 'room_configurations#enable_disappearing_messages',
                                        as: :enable_disappearing_messages
  get '/lock_chat/:room_id', to: 'room_configurations#lock_chat', as: :lock_chat
  post '/configure_chat_lock', to: 'room_configurations#configure_chat_lock', as: :configure_chat_lock

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
