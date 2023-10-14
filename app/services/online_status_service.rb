class OnlineStatusService < ApplicationService
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def call
    user.online = true
    user.last_seen_at = DateTime.now
    user.save(validate: false)
  end
end
