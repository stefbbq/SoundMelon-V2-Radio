class ArtistsController < ApplicationController
	include ArtistsHelper



	def create
		@artist = Artist.new(artist_name: current_user.username)
		@artist.user = current_user		
		if @artist.save
			current_user.attributes.merge(is_artist: true, artist_id: @artist.id)
		end
	end

	def oauth_callback
		conn = oauth_setup
		ids = init_auth_ids
		@result = obtain_token(conn, params[:code], ids)
		@new_tokens = JSON.load(@result.body)
		if @new_tokens.has_key?('error')
			# do something
		else
			create
		end
		# @client = new_client(ids, @new_tokens)
				
	end

	def new_client(ids, new_tokens)
		# Initialize and return a new youtube_it client
		client = YouTubeIt::OAuth2Client.new(client_access_token: new_tokens[:access_token],
																					client_id: ids[:client_id],
																					client_secret: ids[:client_secret],
																					dev_key: ids[:dev_key])
		return client
	end

end
