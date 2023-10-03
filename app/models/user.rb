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
  has_many :messages, through: :connections
  has_many :rooms, through: :connections
end
