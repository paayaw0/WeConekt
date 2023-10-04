class Room < ApplicationRecord
  enum :room_type, {
    single: 0,
    group: 1
  }, prefix: true, scopes: false

  has_one :connection
  has_many :users, through: :connection
  has_many :messages, through: :connection

  after_create_commit -> {
    broadcast_replace_to(
        [:room_creation, connection&.user_id, connection&.target_user_id],
        target: "room_creation_#{connection&.user_id}_#{connection&.target_user_id}",
        partial: 'rooms/join_room',
        locals: {
            target_user_id: connection&.target_user_id,
            pinger_id: connection&.user_id,
            room_id: self.id
        }
    )

    broadcast_replace_to(
        [:room_creation, connection&.target_user_id, connection&.user_id],
        target: "room_creation_#{connection&.target_user_id}_#{connection&.user_id}",
        partial: 'rooms/join_room',
        locals: {
            target_user_id: connection&.target_user_id,
            pinger_id: connection&.user_id,
            room_id: self.id
        }
    )
  }
end
