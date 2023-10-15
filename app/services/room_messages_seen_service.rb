class RoomMessagesSeenService < ApplicationService
  attr_accessor :room, :unseen_messages

  def initialize(room)
    @room = room
    @unseen_messages = room.messages.where(seen_at: nil)
  end

  def call
    # candidate for batch process if messages > 1000
    unseen_messages.each { |message| message.update(seen_at: DateTime.now)}
  end
end