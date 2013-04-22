class SessionsController < ApplicationController

	def new
  end

  def create
  end

  def destroy
		sign_out
  end

end
