module UsersHelper
  def shared_room(pinger, target_user)
    Connection.where(user_id: [pinger.id, target_user.id]).pluck(:room_id).uniq
  end

  def other_user(room, current_user)
    room.users.select { |user| user != current_user }[0]
  end
end
