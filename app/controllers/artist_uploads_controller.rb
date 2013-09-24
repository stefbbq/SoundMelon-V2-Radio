class ArtistUploadsController < ApplicationController
	respond_to :js, :json, :html, :xml
	include ApplicationHelper

	def new
	end

	def create
		params[:artist_upload][:keywords] = params[:artist_upload][:keywords].split(',')
		@artist_upload = ArtistUpload.create(params[:artist_upload])
		if @artist_upload.save
			@artist_upload.update_column(:artist_id, current_artist.id)
		end
	end

	def edit
	end

	def update
		@artist_upload = ArtistUpload.find(params[:id])
		params[:artist_upload][:keywords] = params[:artist_upload][:keywords].split(',')
		@artist_upload.update_attributes(params[:artist_upload])
	end

	def make_public
		@song_id = params[:song_id]
		@upload_source = params[:upload_source]
		if @upload_source == 'youtube'
			@client = new_yt_client(yt_auth_ids, current_artist.youtube_token)
			@song = @client.my_video(@song_id)
			@client.video_update(@song_id, :title => @song.title, :description => @song.description, :category => @song.categories.first.term, :keywords => @song.keywords, :private => false)
		elsif @upload_source == 'soundcloud'
			@client = refresh_sc_client
			@song = @client.get('/tracks/' + @song_id)
			@client.put(@song.uri, :track => {:sharing => 'public'})
		end
	end

	def request_playlist
		@user = current_user
		@station = params[:station]
		update_song_history(@user, params[:played_songs])
		@history = @user.song_history
		@active_songs = ArtistUpload.where(active: true)
		@playlist_size = 3
		if @station == 'random' || (@user.fb_meta.keys.size == 0 && @user.user_meta.size == 0)
#			@active_songs = @active_songs.shuffle[0..(@playlist_size-1)]
			@active_songs = random_playlist(@active_songs, @playlist_size)
		elsif @station == 'your-likes'
			@um_songs = user_scored_songs(@user, @active_songs)
			@active_songs = filter_by_history(@user, @active_songs, @history, @playlist_size)
		end

		@active_ids = []
		@active_songs.each do |song|
			@active_ids << {song_id: song.song_id, upload_source: song.upload_source, keywords: song.keywords, song_url: song.song_url}
		end

		respond_to do |format|
			format.json {render json: @active_ids}
		end
	end

end
