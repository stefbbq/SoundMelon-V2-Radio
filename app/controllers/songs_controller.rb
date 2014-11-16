class SongsController < ApplicationController
	respond_to :js, :json, :html, :xml
	include ApplicationHelper

# 	def new
# 	end
# 
	def create
		params[:song][:source_tags] = params[:song][:source_tags].split(',')
# 		params[:song][:sm_tags] = params[:song][:sm_tags].split(',')
		@items = params
		if !Song.exists?(song_id: params[:song][:song_id])
			@song = Song.create(params[:song].except(:artist_id))
			if @song.save
				@song.update_column(:artist_id, params[:song][:artist_id])
				Artist.find(params[:song][:artist_id]).update_column(:first_song_added, true)
				write_flash('notification', 'Your tune has been uploaded!')
			end
		else
			@song = Song.find_by_song_id(params[:song][:song_id])
			@song.update_attributes(params[:song].except(:artist_id))
		end
	end
# 
# 	def edit
# 	end

	def update
		params[:song][:source_tags] = params[:song][:source_tags].split(',')
# 		params[:song][:sm_tags] = params[:song][:sm_tags].split(',')
		@song = Song.find(params[:id])
		@song.update_attributes(params[:song].except(:artist_id))
		write_flash('notification', 'Your changes have been saved')
	end
	
	def edit
	end

	def show
		
	end

	def make_public
		@song_id = params[:song_id]
		@upload_source = params[:upload_source]
		@artist = Artist.find_by_id(params[:artist_id])
		if @upload_source == 'youtube'
			@client = new_yt_client(yt_auth_ids, @artist.youtube_token)
			@song = @client.my_video(@song_id)
			@client.video_update(@song_id, :title => @song.title, :description => @song.description, :category => @song.categories.first.term, :keywords => @song.keywords, :private => false)
		elsif @upload_source == 'soundcloud'
			@client = refresh_sc_client(@artist)
			@song = @client.get('/tracks/' + @song_id)
			@client.put(@song.uri, :track => {:sharing => 'public'})
		end
		@song_local = Song.find_by_song_id(params[:song_id])
		if @local_song
			@local_song.update_column(:is_private, false)
		end
	end

	def request_playlist
		@items = params
		@user = User.find_by_id(params[:user_id])
		@station = params[:station]
		@empty_fb_meta = @user.fb_meta.nil? || @user.fb_meta.keys.size == 0
		@empty_user_meta = @user.user_meta.nil? || @user.user_meta.size == 0
		if (@empty_fb_meta && @empty_user_meta)
			@station == 'random'
		end
		if @station == 'favorites'
			@active_ids = create_favorites_playlist(@user, params[:song_list])
		else
			update_song_history(@user, params[:played_songs])
			@playlist_size = 3
			@active_ids = create_playlist(@user, @playlist_size, @station)
		end

		respond_to do |format|
			format.json {render json: @active_ids}
			format.js
		end
	end

	def history_reset
		@user = User.find_by_id(params[:user_id])
		@station = params[:station]
		@user.song_history = nil
		@user.save
		@playlist_size = 3
		@station = 'random'
		@active_ids = create_playlist(@user, @playlist_size, @station)
		
		respond_to do |format|
			format.json {render json: @active_ids}
			format.js
		end
	end

	def get_source_tags
		@song_id = params[:song_id]
		@source = params[:source]
		@artist = Artist.find(params[:artist_id])
		if @source == 'youtube'
			@client = new_yt_client(yt_auth_ids, @artist.youtube_token)
			if @artist.youtube_token[:expires_at] < Time.now.to_i
				@client = refresh_yt_client(@client)
			end
			@source_tags = @client.my_video(@song_id).keywords
		elsif @source == 'soundcloud'
			@client = refresh_sc_client(@artist)
			@track = @client.get('/tracks/' + @song_id)
			@source_tags = @track.genre.split() | @track.tag_list.split(' ')
			@source_tags.delete_if {|tag| tag.include? "soundcloud:source"}
		end
		@source_tags = @source_tags.nil? ? [] : @source_tags
	end

end
