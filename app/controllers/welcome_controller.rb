class WelcomeController < ApplicationController
	#respond_to :js, :json, :html, :xml

	def index
		@invite_token = params[:invite_token]
	end

	# def about
	# 	# render 'welcome/about'
	# 	redirect_to '/about/index.html'
	# 	# render file: "/about/index.html"
	# end

	def register
	end


end
