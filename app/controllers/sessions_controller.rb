class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]

  def new
    @redirect_uri = params[:redirect_uri]
  end

  def create
    redirect_uri = login_params[:redirect_uri]

    user = User.find_by(email: login_params[:email])

    if user&.authenticate_password(login_params[:password])
      login_user(user)
      handle_room_authentication(redirect_uri) unless redirect_uri.blank?

      flash[:success] = "Welcome Back, #{user.name || user.username}"

      redirect_to(redirect_uri.blank? ? users_path : redirect_uri)
    else
      flash.now[:error] = 'Invalid email/password'
      render :new, status: 401
    end
  end

  def destroy
    log_out

    flash[:success] = "You've successfully logged out"
    redirect_to login_path
  end

  private

  def login_params
    params.permit(
      :email,
      :password,
      :redirect_uri
    )
  end

  def handle_room_authentication(redirect_uri)
    room_id = redirect_uri.split('/').last.to_i
    room_config = RoomConfiguration.find_by(room_id:, user_id: current_user.id)
    room_config.update(chat_lock_token: SecureRandom.alphanumeric(25))
  end
end
