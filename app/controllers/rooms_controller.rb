class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :destroy]

  def index
    @rooms = current_user.rooms
  end

  def show
    @users = User.all
  end

  def join
    @pinger = User.find_by(id: params[:pinger_id])
    @target_user = User.find_by(id: params[:target_user_id])
    @room = Room.find_by(id: params[:room_id])

    redirect_to room_path(@room)
  end

  def destroy
    @room.connections.destroy_all
    @room.messages.destroy_all
    @room.destroy
  end

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
