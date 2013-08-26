class ApplicationController < ActionController::Base
  protect_from_forgery
	include SessionsHelper

	$localtunnel_add = 'http://10.0.0.105:3000'
  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
end
