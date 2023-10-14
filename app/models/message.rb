class Message < ApplicationRecord
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

  after_update_commit -> {
    broadcast_replace_to(
      [:room, room&.id],
      target: self,
      partial: 'messages/message',
      locals: {
        message: self
      }
    )
  }

  after_destroy -> {
    broadcast_remove_to(
      [:room, room&.id],
      target: self,
      locals: [
        user: self
      ]
    )
  }
end
