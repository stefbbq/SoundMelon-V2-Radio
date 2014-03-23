class FeedbacksController < ApplicationController
	include ApplicationHelper
	respond_to :js, :json, :html, :xml

	def new
		@report = Feedback.new
	end

	def create
		@category = params[:feedback][:category]
		@content = params[:feedback][:content]
		if @content.size > 0
			@report = Feedback.new(params[:feedback])
			@report.save
		elsif @content.size == 0
			write_flash('error', 'Please fill out the form completely')
		end
	end

end
