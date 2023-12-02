class OnlineStatusChannel < ApplicationCable::Channel
  def subscribed
    room_id = params[:room_id] || current_room&.id || current_user.current_room&.id
    return unless room_id

    room = Room.find(room_id)

    OnlineStatusService.call(current_user, connect_online: true)
    CurrentRoomService.call(current_user, room)

    send_message({
                   body: "#{current_user.name} just joined",
                   room_id:,
                   current_user_id: current_user.id
                 })

    stream_from "online_users_rooms_id_#{room_id}"
  end

  def unsubscribed
    room_id = params[:room_id] || current_room&.id || current_user.current_room&.id
    return unless room_id

    room = Room.find(room_id)

    OnlineStatusService.call(current_user)
    CurrentRoomService.call(current_user, room, set_current_connection: false)
    RoomLockAuthenticationService.call(current_user, room, re_authenticate: true)

    send_message({
                   body: "#{current_user.name} just left!",
                   room_id:,
                   current_user_id: current_user.id
                 })
  end

  def send_message(data = {})
    ActionCable.server.broadcast("online_users_rooms_id_#{data[:room_id]}", data)
  end
end
