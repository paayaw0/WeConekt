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
    current_user.online = false
    current_user.save(validate: false)
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in?
    current_user
  end
end
