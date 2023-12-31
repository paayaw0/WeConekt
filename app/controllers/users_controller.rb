class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]
  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.all.excluding(current_user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    @user.last_logged_in_at = DateTime.now

    if @user.save
      login_user(@user)

      flash[:success] = "Hello #{@user.name || @user.username} and welcome to WeConekt"
      redirect_to user_path(@user)
    else
      flash.now[:error] = 'Failed to create your profile. Please check and resolve the errors'
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'You successful updated your profile'
      redirect_to user_path(@user)
    else
      flash.now[:error] = 'Profile update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    raise ErrorHandler::AuthenticationError unless current_user

    @user = User.find_by(id: params[:id])
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
