class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: login_params[:email])

    if user&.authenticate_password(login_params[:password])
      login_user(user)

      flash[:success] = "Welcome Back, #{user.name || user.username}"
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid email/password'
      render :new, status: 401
    end
  end

  def destroy
    log_out

    flash[:notice] = "You've successfully logged out"
    redirect_to login_path
  end

  private

  def login_params
    params.permit(
      :email,
      :password
    )
  end
end
