class OnlineStatusChannel < ApplicationCable::Channel
  def subscribed
    OnlineStatusService.call(current_user, connect_online: true)
    room_id = params[:room_id]
    send_message({body: "#{current_user.name} just joined", room_id:})
    
    stream_from "online_users_room_id_#{room_id}"
  end

  def unsubscribed
    OnlineStatusService.call(current_user)
    room_id = params[:room_id]
    send_message({body: "#{current_user.name} just left!", room_id:})
    current_room_connection.update(current: false)
  end

  def send_message(data={})
    ActionCable.server.broadcast("online_users_room_id_#{params[:room_id]}", data)
  end
end
