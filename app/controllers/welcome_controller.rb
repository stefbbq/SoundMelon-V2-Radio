class WelcomeController < ApplicationController
	#respond_to :js, :json, :html, :xml

	def index
		@invite_token = params[:invite_token]
	end

	def register
	end


end
