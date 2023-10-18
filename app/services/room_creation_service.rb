class RoomCreationService < ApplicationService
  attr_accessor :pinger, :target_user

  def initialize(pinger, target_user)
    @pinger = pinger
    @target_user = target_user
  end

  def call
    room = Room.new(
      name: "#{target_user&.username}-#{pinger&.username} #{rand(100)}",
      room_type: 0
    )

    pinger_connection = pinger.connections.new(
      room:,
    )

    target_connection = target_user.connections.new(
      room:
    )

    room.connections << [pinger_connection, target_connection]
    room.save
  end
end