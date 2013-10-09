class FeedbacksController < ApplicationController
	respond_to :js, :json, :html, :xml

	def new
		@report = Feedback.new
	end

	def create
		@report = Feedback.new(params[:feedback])
		@report.save
	end

end
