class RoomsController < ApplicationController
  before_action :set_room, only: %i[show destroy]
  before_action :activate_room_chat_lock_authentication!, only: %i[show]

  def index
    @rooms = current_user.rooms
  end

  def show
    @users = @room.users
    set_current_room(@room)
  end

  def join
    @room = Room.find_by(id: params[:room_id])
    set_current_room(@room)

    redirect_to room_path(@room)
  end

  def leave
    unset_current_room

    redirect_to users_url
  end

  def destroy; end

  private

  def room_params
    params.require(:room).permit(
      :name,
      :room_type
    )
  end

  def set_room
    @room = Room.find_by(id: params[:id])
  end

  def activate_room_chat_lock_authentication!
    room_config = RoomConfiguration.find_by(room: @room, user: current_user)

    return unless room_config.chat_locked? && room_config.chat_lock_token.nil?

    flash[:error] = 'You must sign in first'
    session.clear
    redirect_to login_path(
      redirect_uri: room_url(@room)
    )
  end
end
