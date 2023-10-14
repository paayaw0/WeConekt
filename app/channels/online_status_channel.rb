class OnlineStatusChannel < ApplicationCable::Channel
  def subscribed
    current_user.online = true
    current_user.last_seen_at = DateTime.now 
    current_user.save(validate: false)

    stream_from 'online_users'
  end

  def unsubscribed
    current_user.online = false
    current_user.save(validate: false)
  end
end
