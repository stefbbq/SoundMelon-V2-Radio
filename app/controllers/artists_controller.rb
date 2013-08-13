class ArtistsController < ApplicationController
	include ArtistsHelper
	helper_method :init_auth_ids, :new_client

	def create
		@artist = Artist.new(artist_name: current_user.username)
		@artist.user = current_user
		if @artist.save
			current_user.update_column(:is_artist, true)
			current_user.update_column(:artist_id, @artist.id)
		end
	end

	def show
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
			current_artist.update_attributes(youtube_token: @new_tokens)
#			@client = new_client(ids, @new_tokens["access_token"])
			redirect_to root_path
		end
				
	end



end
