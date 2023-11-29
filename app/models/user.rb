class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  MAX_SESSION_TIME = 2.weeks

  has_secure_password

  before_save do
    self.email = email.downcase
    self.username = email.split('@')[0] if username.nil?
  end

  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, unless: ->(obj) { obj.persisted? && obj.password.nil? }
  validates :password, strong_password: true, unless: ->(obj) { obj.persisted? && obj.password.nil? }

  has_many :connections
  has_many :messages
  has_many :rooms, through: :connections
  has_many :shared_messages
  has_one :room_configuration

  after_update_commit lambda {
    if rooms.any?
      rooms.each do |room|
        broadcast_replace_to(
          "online_users_rooms_id_#{room.id}",
          target: self,
          partial: 'users/online_status',
          locals: {
            user: self,
            room:
          }
        )
      end
    end
  }

  def has_connected_with?(user)
    rooms = connections.pluck(:room_id)
    Connection.where(room_id: [rooms], user_id: user.id).any?
  end

  def current_room
    connections.find_by(current: true)&.room # user can only have one connections current at a time
  end

  def online_in_this_room?(room)
    online? && room == current_room
  end
end
