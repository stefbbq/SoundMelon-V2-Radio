class FeedbacksController < ApplicationController
	include ApplicationHelper
	respond_to :js, :json, :html, :xml

	def new
		@report = Feedback.new
	end

	def create
		@email = params[:feedback][:email]
		@title = params[:feedback][:title]
		@content = params[:feedback][:content]
		@formatted = validate_email(@email)
		flash[:error] = nil
		if @formatted && @title.size > 0 && @content.size > 0
			@report = Feedback.new(params[:feedback])
			@report.save
		elsif !@formatted
			flash[:error] = 'Invalid email address'
		elsif @title.size > 0 || @content.size > 0
			flash[:error] = 'Please fill out the form completely'
		end
	end

end
