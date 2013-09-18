class SessionsController < ApplicationController

	def new
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
		respond_to do |format|
			format.js
		end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

end
