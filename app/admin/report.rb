ActiveAdmin.register Report do
	actions :all, except: [:edit, :destroy]

  action_item only: [:show] do |resource|
		if Report.find(params[:id]).open
    	link_to "Agree", {:action => 'agree'}, :method => :put
		else
			link_to "Re-Open", {:action => 'reopen_report'}, :method => :put
		end
  end

	index do
		selectable_column
		column :id
		column :title
		column :content
		column :reportable_type
		column :open
		column :created_at
		column :updated_at
		actions defaults: true
	end

	member_action :agree, method: :put do
		@report = Report.find(params[:id])
		@song = ArtistUpload.find(@report.reportable_id)
		@artist = @song.artist
		@reported_user = @artist.user
	end

	member_action :reopen_report, method: :put do
		@report = Report.find(params[:id])
		@song = ArtistUpload.find(@report.reportable_id)
		@report.open = true
		@report.save
		@song.blocked = false
		@song.save
		redirect_to :action => :show
	end

	member_action :block_song, method: :post do
		@report = Report.find(params[:report_id])
		@song = ArtistUpload.find(@report.reportable_id)
#		@artist = @song.artist
#		@reported_user = @artist.user
		UserMailer.admin_message(params[:email], params[:subject], params[:body]).deliver
		@song.blocked = true
		@song.active = false
		@song.save
		@blocked = BlockedUpload.new(upload_source: @song.upload_source, song_id: @song.song_id)
		@blocked.save
		@report.open = false
		@report.save
		redirect_to :action => :show
	end

end
