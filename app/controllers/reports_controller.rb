class ReportsController < ApplicationController


	def report_song
		@user = User.find_by_id(params[:user_id])
		@song = ArtistUpload.find_by_song_id(params[:song_id])
	end

	def send_report
		@user = User.find(params[:report][:user_id])
		report = Report.new(params[:report].except(:user_id))
		report.user = @user
		if report.save
			@report = report
		end
	end

end
