class OnlineStatusChannel < ApplicationCable::Channel
  def subscribed
    OnlineStatusService.call(current_user)

    stream_from 'online_users'
  end

  def unsubscribed
    current_user.online = false
    current_user.save(validate: false)
  end
end
