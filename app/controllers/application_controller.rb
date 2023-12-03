class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include SessionsHelper
  include ErrorHandler

  private

  def authenticate_user!
    reset_session_if_inactive

    raise ErrorHandler::AuthenticationError unless current_user
  end
end
