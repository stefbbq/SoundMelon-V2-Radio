ActiveAdmin.register Report do
	actions :all, except: [:edit, :destroy]

#	index do
#		selectable_column
#		column :id
#		column :title
#		column :content
#		column :reportable_id
#		column :reportable_type
#		column :open
#		column :resolution
#		column :created_at
#		column :updated_at
#		actions defaults: true
#	end

	show do
    attributes_table do
			row :id
			row :title
			row :content
			row :user_id
			row :reportable_type
			row :reportable_id
			row :created_at
			row :updated_at
			row :open
			row :resolution
    end
		is_open = Report.find(params[:id]).open
		panel "" do
			if is_open
		  	link_to("Block Song", {:action => 'agree'}, :method => :put)
			else
				link_to "Re-Open", {:action => 'reopen_report'}, :method => :put
			end
		end
		panel "" do
			if is_open
				link_to("Allow Song", {:action => 'disagree'}, :method => :put)
			end
		end
    active_admin_comments
	end

	member_action :agree, method: :put do
		@report = Report.find(params[:id])
		@song = ArtistUpload.find(@report.reportable_id)
		@artist = @song.artist
		@reported_user = @artist.user
	end

	member_action :disagree, method: :put do
		@report = Report.find(params[:id])
		@song = ArtistUpload.find(@report.reportable_id)
		@user = @report.user
	end

	member_action :reopen_report, method: :put do
		@report = Report.find(params[:id])
		@song = ArtistUpload.find(@report.reportable_id)
		@report.open = true
		@report.save
		@song.blocked = false
		@song.save
		BlockedUpload.find_by_song_id(@song.song_id).destroy if BlockedUpload.exists?(song_id: @song.song_id)
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
		@blocked = BlockedUpload.find_by_song_id(@song.song_id).nil? ? BlockedUpload.new(upload_source: @song.upload_source, song_id: @song.song_id) : BlockedUpload.find_by_song_id(@song.song_id)
		@blocked.save
		@report.open = false
		@report.resolution = 'blocked'
		@report.save
		redirect_to :action => :show
	end

	member_action :invalid_report, method: :post do
		@report = Report.find(params[:report_id])
		UserMailer.admin_message(params[:email], params[:subject], params[:body]).deliver
		@report.open = false
		@report.resolution = 'allowed'
		@report.save
		redirect_to :action => :show
	end

end
