class OnlineStatusService < ApplicationService
  attr_accessor :user, :connect_online

  def initialize(user, connect_online: false)
    @user = user
    @connect_online = connect_online
  end

  def call
    user.online = connect_online

    user.last_seen_at = DateTime.now
    user.save(validate: false)
  end
end
