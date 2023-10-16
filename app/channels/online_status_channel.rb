class OnlineStatusChannel < ApplicationCable::Channel
  def subscribed
    OnlineStatusService.call(current_user, connect_online: true)

    stream_from 'online_users'
  end

  def unsubscribed
    OnlineStatusService.call(current_user)
    current_room_connection.update(current: false)
  end
end
