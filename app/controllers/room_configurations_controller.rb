class RoomConfigurationsController < ApplicationController
  before_action :set_room, only: %i[set_disappearing_messages lock_chat]

  def set_disappearing_messages; end

  def enable_disappearing_messages
    user = User.find_by(id: room_config_params[:user_id])
    room = Room.find_by(id: room_config_params[:room_id])
    duration = room_config_params[:disappearing_messages].to_i

    room_config = RoomConfiguration.find_or_create_by(
      user_id: user.id,
      room_id: room.id
    )
    room_config.disappearing_messages = duration.zero? ? nil : duration

    user.room_configuration = room_config

    room.broadcast_replace_to(
      [:user_room_config, room.id, user.id],
      target: "disappearing_messages_#{room.id}_#{user.id}",
      partial: 'room_configurations/disappearing_messages',
      locals: {
        room:,
        user:
      }
    )
  end

  def lock_chat
    @room_configuration = RoomConfiguration.find_or_initialize_by(room_id: @room.id)
  end

  def configure_chat_lock
    user = User.find_by(id: room_config_params[:user_id])
    room = Room.find_by(id: room_config_params[:room_id])

    room_config = RoomConfiguration.find_or_create_by(
      user_id: user.id,
      room_id: room.id
    )

    lock_configuration = !room_config_params[:chat_locked].to_i.zero?
    token = lock_configuration ? SecureRandom.alphanumeric(25) : nil

    room_config.update(chat_locked: lock_configuration, chat_lock_token: token)

    room.broadcast_replace_to(
      [:user_room_config, room.id, current_user.id],
      target: "chat_lock_#{room.id}",
      partial: 'room_configurations/chat_lock',
      locals: {
        room:,
        user: current_user
      }
    )
  end

  private

  def set_room
    @room = Room.find_by(id: params[:room_id])
  end

  def room_config_params
    params.require(:room_configuration).permit(
      :disappearing_messages,
      :room_id,
      :user_id,
      :chat_locked
    )
  end
end
