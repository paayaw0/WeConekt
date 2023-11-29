class RoomsController < ApplicationController
  before_action :set_room, only: %i[show destroy]

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
end
