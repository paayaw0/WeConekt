module SessionsHelper
  def login_user(user)
    session[:user_id] = user.id
    user.last_logged_in_at = DateTime.now
    user.save(validate: false)
  end

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_out
    raise ErrorHandler::AuthenticationError unless current_user

    current_user.last_logged_out_at = DateTime.now
    OnlineStatusService.call(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in?
    current_user
  end

  def set_current_room(room)
    return unless current_user
    return unless room

    session[:room_id] = room.id
    current_user.connections.update_all(current: false) # there can only be one current connection to reflect that there can only be on current_room at a time for the current user
    connection = Connection.find_by(room_id: room.id, user_id: current_user.id)
    connection.update(current: true, last_connected_at: DateTime.now)
    session[:connection_id] = connection.id
    OnlineStatusService.call(current_user, connect_online: true)
    RoomMessagesSeenService.call(room)
  end

  def unset_current_room
    return unless current_room

    connection = Connection.find_by(room_id: current_room.id, user_id: current_user.id)
    connection.update(current: false)
    session.delete(:connection_id)
    session.delete(:room_id)
    OnlineStatusService.call(current_user)
    @current_room = nil
    @current_connection = nil
  end

  def current_room
    @current_room ||= Room.find_by(id: session[:room_id])
  end

  def current_connection
    @current_connection ||= (Connection.find_by(id: session[:connection_id]) || Connection.find_by(current: true))
  end
end
