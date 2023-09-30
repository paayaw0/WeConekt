module ErrorHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end

  included do
    rescue_from ErrorHandler::AuthenticationError, with: :unauthenticated_request
  end

  private

  def unauthenticated_request(_e)
    flash[:error] = 'You must be signed in first'
    redirect_to login_path
  end
end
