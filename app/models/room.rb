class Room < ApplicationRecord
  enum :room_type, {
    single: 0,
    group: 1
  }, prefix: true, scopes: false

  has_one :connection
  has_many :users, through: :connection
  has_many :messages, through: :connection
end
