class CurrentRoomService < ApplicationService
  attr_accessor :room, :connection, :user, :set_current_connection

  def initialize(user, room, set_current_connection: true)
    @user = user
    @room = room
    @connection = Connection.find_by(room_id: room.id, user_id: user.id)
    @set_current_connection = set_current_connection
  end

  def call
    if set_current_connection
      user.connections.update_all(current: false) # there can only be one current connection to reflect that there can only be on current_room at a time for the current user
      connection.update(current: true, last_connected_at: DateTime.now)
    else
      connection.update(current: false)
    end
  end
end
