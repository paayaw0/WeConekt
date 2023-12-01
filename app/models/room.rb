class Room < ApplicationRecord
  enum :room_type, {
    single: 0,
    group: 1
  }, prefix: true, scopes: false

  has_many :connections
  has_many :users, through: :connections
  has_many :messages
  has_and_belongs_to_many :shared_messages
  has_one :room_configuration

  after_create_commit lambda {
    user_id = connections.first.user_id
    target_user_id = connections.last.user_id

    broadcast_replace_to(
      [:room_creation, user_id, target_user_id],
      target: "room_creation_#{user_id}_#{target_user_id}",
      partial: 'rooms/join_room',
      locals: {
        target_user_id:,
        pinger_id: user_id,
        room_id: id
      }
    )

    broadcast_replace_to(
      [:room_creation, target_user_id, user_id],
      target: "room_creation_#{target_user_id}_#{user_id}",
      partial: 'rooms/join_room',
      locals: {
        target_user_id:,
        pinger_id: user_id,
        room_id: id
      }
    )
  }

  def other_user(user)
    users.select { |u| u != user }[0]
  end

  def room_name(user)
    other_user(user).username.titlecase
  end
end
