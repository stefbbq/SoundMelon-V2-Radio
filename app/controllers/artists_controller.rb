class ArtistsController < ApplicationController
	include ApplicationHelper
	helper_method :yt_auth_ids, :sc_auth_ids, :new_yt_client
	require 'soundcloud'

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

	def yt_request
		ids = yt_auth_ids
		yt_authorize_url = 'https://accounts.google.com/o/oauth2/auth?client_id=' + ids[:client_id] + '&redirect_uri=' + ids[:redirect_uri] + '&scope=' + ids[:yt_scope] + '&response_type=code&approval_prompt=force&access_type=offline'
		redirect_to yt_authorize_url
	end

	def yt_oauth_callback
		conn = yt_oauth_setup
		ids = yt_auth_ids
		@result = obtain_yt_token(conn, params[:code], ids)
		@new_tokens = Hash.transform_keys_to_symbols(JSON.load(@result.body))
		@new_tokens[:expires_at] = Time.parse(@result.env[:response_headers][:date]).to_i + @new_tokens[:expires_in]  
		if !@new_tokens.has_key?(:error)
			if !current_user.is_artist?
				create
			end
			current_artist.update_attributes(youtube_token: @new_tokens)
		end
		redirect_to root_path
	end

#	def yt_show
#	end

	def sc_request
		client = Soundcloud.new(sc_auth_ids)
		redirect_to client.authorize_url()
	end

	def sc_oauth_callback
		@client = Soundcloud.new(sc_auth_ids)
		if !params.has_key?('error')
			@client.exchange_token(code: params[:code])
			@new_tokens = @client.options.except(:on_exchange_token)
			if !current_user.is_artist?
				create
			end
			current_artist.update_attributes(soundcloud_token: @new_tokens)
		end
		redirect_to root_path
	end

#	def sc_show
#	end

end
