class SessionsController < ApplicationController

	def new
  end

  def create
  end

  def destroy
		#sign_out
    current_user = nil
    cookies.delete(:remember_token)
  end

end
