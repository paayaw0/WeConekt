class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include SessionsHelper
  include ErrorHandler

  private

  def authenticate_user!
    raise ErrorHandler::AuthenticationError unless current_user
  end
end
