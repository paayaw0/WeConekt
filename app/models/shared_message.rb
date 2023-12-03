class SharedMessage < ApplicationRecord
  belongs_to :message
  belongs_to :room
  belongs_to :user, touch: true
  has_and_belongs_to_many :rooms

  after_create_commit lambda {
    broadcast_replace_to(
      [:room, message.room&.id],
      target: message,
      partial: 'messages/message',
      locals: {
        message:
      }
    )

    rooms.each do |room|
      message_copy = create_copy_of_message(message, room.id)

      broadcast_append_to(
        [:room, room&.id],
        target: "room_#{room&.id}",
        partial: 'messages/message',
        locals: {
          message: message_copy
        }
      )
    end
  }

  def author
    user
  end

  def from
    message.room
  end

  def to
    room
  end

  private

  def create_copy_of_message(message, room_id_)
    room = Room.find(room_id_)

    Message.create(
      text: message.text,
      user_id: message.user_id,
      room_id: room_id_,
      copied_from: author.id,
      copied_to: room.other_user(author).id,
      copy: true
    )
  end
end
