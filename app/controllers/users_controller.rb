class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def new; end

  def create
    @user = User.new(user_params)

    if @user.save
      login_user(@user)

      flash[:success] = "Hello #{@user.name || @user.username} and welcome to WeConekt"
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid Email/Password'
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'You successful updated your profile'
      redirect_to root_path
    else
      flash.now[:error] = 'Profile update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    raise ErrorHandler::AuthenticationError unless current_user

    @user = User.find_by(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :username,
      :email,
      :password
    )
  end
end
