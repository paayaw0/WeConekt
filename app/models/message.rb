class Message < ApplicationRecord
  belongs_to :connection
  belongs_to :user
  belongs_to :room

  after_create_commit -> {
    broadcast_append_to(
      [:room, room&.id],
      target: "room_#{room&.id}",
      partial: 'messages/message',
      locals: {
        message: self
      }
    )
  }
end
