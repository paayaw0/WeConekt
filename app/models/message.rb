class Message < ApplicationRecord
  EDIT_OR_DELETE_TIME_WINDOW = 15.minutes

  encrypts :text

  belongs_to :user, touch: true
  belongs_to :room, touch: true
  has_many :shared_messages

  validates :text, presence: true

  before_save lambda {
    self.seen_at = DateTime.now if other_user&.online?
  }

  after_create_commit lambda {
    broadcast_append_to(
      [:room, room&.id],
      target: "room_#{room&.id}",
      partial: 'messages/message',
      locals: {
        message: self
      }
    )

    broadcast_replace_to(
      "online_users_rooms_id_#{room_id}",
      target: "toggle_delete_#{id}",
      partial: 'messages/message_crud_options',
      locals: {
        message: self
      }
    )
  }, unless: proc { |message| message.copy == true }

  after_update_commit lambda {
    broadcast_replace_to(
      [:room, room&.id],
      target: self,
      partial: 'messages/message',
      locals: {
        message: self
      }
    )

    broadcast_replace_to(
      "online_users_rooms_id_#{room_id}",
      target: "toggle_delete_#{id}",
      partial: 'messages/message_crud_options',
      locals: {
        message: self
      }
    )
  }

  after_destroy lambda {
    broadcast_remove_to(
      [:room, room&.id],
      target: "message_#{id}"
    )
  }

  def other_user
    room.users.select { |u| u != user }[0]
  end

  def seen?
    seen_at
  end

  def able_to_edit?
    return false if copy?

    (created_at + EDIT_OR_DELETE_TIME_WINDOW) > DateTime.now
  end

  def copies
    Message.where(text:, copy: true)
  end

  def original
    self.class.find_by(text:, copy: false)
  end

  def is_copy?
    copy?
  end

  def is_original?
    !copy?
  end

  def has_copies?
    copies.any?
  end

  def deleted?
    delete_for_everyone
  end

  def author
    user
  end
end
