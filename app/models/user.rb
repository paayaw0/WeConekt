class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password

  before_save do
    self.email = email.downcase
    self.username = email.split('@')[0] if username.nil?
  end

  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password, strong_password: true

  has_many :connections
  has_many :messages
  has_many :rooms, through: :connections

  def has_connected_with?(user)
    rooms = connections.pluck(:room_id)
    Connection.where(room_id: [rooms], user_id: user.id).any?
  end
end
