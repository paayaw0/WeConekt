class RoomLockAuthenticationService < ApplicationService
  attr_reader :user, :room, :re_authenticate, :room_config

  def initialize(user, room, re_authenticate: false)
    @user = user
    @room = room
    @re_authenticate = re_authenticate
    @room_config = RoomConfiguration.find_by(user:, room:)
  end

  def call
    return unless room_config.chat_locked?
    return unless re_authenticate

    room_config.update(chat_lock_token: nil, chat_locked: true)
  end
end
