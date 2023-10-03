class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :messages
end
