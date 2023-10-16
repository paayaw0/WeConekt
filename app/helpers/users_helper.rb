module UsersHelper
  def shared_room(pinger, target_user)
    target_rooms = target_user.connections.pluck(:room_id)
    pinger_rooms = pinger.connections.pluck(:room_id)

    target_rooms & pinger_rooms
  end

  def other_user(room, current_user)
    room.users.select { |user| user != current_user }[0]
  end
end
