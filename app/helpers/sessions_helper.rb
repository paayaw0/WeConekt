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
    CurrentRoomService.call(current_user, current_room, set_current_connection: false) if current_room
    session.clear
    @current_user = nil
  end

  def logged_in?
    current_user
  end

  def set_current_room(room)
    return unless current_user
    return unless room

    session[:room_id] = room.id

    CurrentRoomService.call(current_user, current_room)

    session[:connection_id] = current_connection.id

    OnlineStatusService.call(current_user, connect_online: true)
  end

  def unset_current_room
    return unless current_room

    CurrentRoomService.call(current_user, current_room, set_current_connection: false)

    session.delete(:connection_id)
    session.delete(:room_id)

    OnlineStatusService.call(current_user)

    @current_room = nil
    @current_connection = nil
  end

  def current_room
    @current_room = Room.find_by(id: session[:room_id])
  end

  def current_connection
    @current_connection = (current_user.connections.find_by(id: session[:connection_id]) || current_user.connections.find_by(current: true))
  end

  def reset_session_if_inactive
    return unless current_user

    inactive = current_user.updated_at < User::MAX_SESSION_TIME.ago

    return unless inactive

    session.clear
  end
end
