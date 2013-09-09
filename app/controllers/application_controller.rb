class ApplicationController < ActionController::Base
	helper ApplicationHelper
  protect_from_forgery
#	include SessionsHelper

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
#    sign_out
    super
  end
end
