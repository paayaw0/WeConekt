class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_create_commit lambda {
    broadcast_append_to(
      [:room, room&.id],
      target: "room_#{room&.id}",
      partial: 'messages/message',
      locals: {
        message: self
      }
    )
  }

  after_update_commit lambda {
    broadcast_replace_to(
      [:room, room&.id],
      target: self,
      partial: 'messages/message',
      locals: {
        message: self
      }
    )
  }

  after_destroy lambda {
    broadcast_remove_to(
      [:room, room&.id],
      target: self
    )
  }
end
