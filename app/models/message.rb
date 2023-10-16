class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :text, presence: true

  before_save -> {
    self.seen_at = DateTime.now if other_user&.online?
  }

  after_create_commit -> {
    broadcast_append_to(
      [:room, room&.id],
      target: "room_#{room&.id}",
      partial: 'messages/message',
      locals: {
        message: self
      }
    )

    broadcast_replace_to(
      'online_users',
      target: "toggle_delete_#{id}",
      partial: 'users/toggle_delete_action',
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

    broadcast_replace_to(
      'online_users',
      target: "toggle_delete_#{id}",
      partial: 'users/toggle_delete_action',
      locals: {
        message: self
      }
    )
  }

  after_destroy -> {
    broadcast_remove_to(
      [:room, room&.id],
      target: self
    )
  }

  def other_user
    room.users.select { |u| u != user }[0]
  end

  def seen?
    seen_at
  end
end
