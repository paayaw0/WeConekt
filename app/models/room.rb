class Room < ApplicationRecord
  enum :room_type, {
    single: 0,
    group: 1
  }, prefix: true, scopes: false

  has_many :connections
  has_many :users, through: :connections
  has_many :messages
  

  after_create_commit -> {
    user_id = connections.first.user_id
    target_user_id = connections.last.user_id

    broadcast_replace_to(
        [:room_creation, user_id, target_user_id],
        target: "room_creation_#{user_id}_#{target_user_id}",
        partial: 'rooms/join_room',
        locals: {
            target_user_id: target_user_id,
            pinger_id: user_id,
            room_id: self.id
        }
    )

    broadcast_replace_to(
        [:room_creation, target_user_id, user_id],
        target: "room_creation_#{target_user_id}_#{user_id}",
        partial: 'rooms/join_room',
        locals: {
            target_user_id: target_user_id,
            pinger_id: user_id,
            room_id: self.id
        }
    )
  }
end
