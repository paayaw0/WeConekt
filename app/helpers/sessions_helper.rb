module SessionsHelper
  def login_user(user)
    session[:user_id] = user.id
  end

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_out
    raise ErrorHandler::AuthenticationError unless current_user

    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in?
    current_user
  end
end
