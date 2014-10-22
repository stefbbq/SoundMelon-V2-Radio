class ApplicationController < ActionController::Base
	helper ApplicationHelper
  protect_from_forgery
#	include SessionsHelper

  # def after_sign_in_path_for(resource_or_scope)
  #   if request.env['omniauth.origin']
  #     request.env['omniauth.origin']
  #   end
  # end

  private
  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end

#	def current_artist=(artist)
#    @current_artist = artist
#  end
  
  def current_artist
		if current_user.is_artist?
    	@current_artist ||= Artist.find_by_id(current_user.artist_id)
  	end
	end
  helper_method :current_user
	helper_method :current_artist

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
#    sign_out
    super
  end
end
