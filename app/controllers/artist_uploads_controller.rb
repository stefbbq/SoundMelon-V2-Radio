class ArtistUploadsController < ApplicationController
	respond_to :js, :json, :html, :xml
	include ApplicationHelper

	def new
	end

	def create
		@artist_upload = ArtistUpload.create(params[:artist_upload])
		if @artist_upload.save
			@artist_upload.update_column(:artist_id, current_artist.id)
		end
	end

	def edit
	end

	def update
		@artist_upload = ArtistUpload.find(params[:id])
		@artist_upload.update_attributes(params[:artist_upload])
	end

	def make_public
		@song_id = params[:song_id]
		@upload_source = params[:upload_source]
		if @upload_source == 'youtube'
			@client = refresh_yt_client
			@song = @client.my_video(@song_id)
			@client.video_update(@song_id, :title => @song.title, :description => @song.description, :category => @song.categories.first.term, :keywords => @song.keywords, :private => false)
		elsif @upload_source == 'soundcloud'
			@client = refresh_sc_client
			@song = @client.get('/tracks/' + @song_id)
			@client.put(@song.uri, :track => {:sharing => 'public'})
		end
	end

end
