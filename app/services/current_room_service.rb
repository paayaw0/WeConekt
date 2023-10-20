class CurrentRoomService < ApplicationService
  attr_accessor :room, :connection, :user, :set_current_connection

  def initialize(user, room, set_current_connection: true)
    @user = user
    @room = room
    @connection = user.connections.find_by(room_id: room.id)
    @set_current_connection = set_current_connection
  end

  def call
    max_tries = 5

    user.connections.update_all(current: false) if set_current_connection # there can only be one current connection to reflect that there can only be on current_room at a time for the current user
    connection.reload.with_lock do
      connection.update(current: set_current_connection, last_connected_at: DateTime.now)
    end
  rescue ActiveRecord::StatementInvalid
    if max_tries >= 0
      max_tries -= 1
      retry
    end
  end
end
