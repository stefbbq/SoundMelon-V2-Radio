module ApplicationHelper

	def yt_auth_ids
		# Return a hash that initializes youtube authentication relevant parameters 
		ids = {client_id: ENV["YOUTUBE_APP_ID"],
					 client_secret: ENV["YOUTUBE_SECRET"],
					 redirect_uri: ENV["HOST_ADDR"] + '/yt_oauth_callback',
					 yt_scope: 'https://gdata.youtube.com',
					 dev_key: ENV["YOUTUBE_DEV_KEY"]
					}
		return ids
	end

	def sc_auth_ids
		ids = {client_id: ENV["SOUNDCLOUD_APP_ID"],
					 client_secret: ENV["SOUNDCLOUD_SECRET"],
					 redirect_uri: ENV["HOST_ADDR"] + '/sc_oauth_callback'}
	end

	def yt_oauth_setup
		# Return a Faraday object for Google-Youtube
		conn = Faraday.new(:url => 'https://accounts.google.com',:ssl => {:verify => false}) do |faraday|
		 faraday.request  :url_encoded
		 faraday.response :logger
		 faraday.adapter  Faraday.default_adapter
		end
		return conn
	end

	def obtain_yt_token(conn, client_token, ids)
		# Return Faraday attribute containing the youtube authentication token
		result = conn.post '/o/oauth2/token', {code: client_token,
																					client_id: ids[:client_id],
																					 client_secret: ids[:client_secret],
																					 redirect_uri: ids[:redirect_uri],
																					 grant_type: 'authorization_code'}
		
		return result
	end

	def new_yt_client(ids, token, refresh_token)
		# Initialize and return a new youtube_it client
		client = YouTubeIt::OAuth2Client.new(client_access_token: token,
																					client_refresh_token: refresh_token,
																					client_id: ids[:client_id],
																					client_secret: ids[:client_secret],
																					dev_key: ids[:dev_key])
		return client
	end

	def refresh_yt_client
		yt_ids = yt_auth_ids
		yt_tokens = current_artist.youtube_token
		yt_client = new_yt_client(yt_ids, yt_tokens[:access_token], yt_tokens[:refresh_token])
		yt_client.refresh_access_token!
		yt_tokens[:access_token] = yt_client.access_token.token
		yt_tokens[:refresh_token] = yt_client.access_token.refresh_token
		current_artist.update_attributes(youtube_token: yt_tokens)
		return yt_client
	end

	def refresh_sc_client
		sc_ids = sc_auth_ids
		sc_tokens = current_artist.soundcloud_token
		sc_client = Soundcloud.new(client_id: sc_ids[:client_id], client_secret: sc_ids[:client_secret], refresh_token: sc_tokens[:refresh_token])
		current_artist.update_attributes(soundcloud_token: sc_client.options.except(:on_exchange_token))
		return sc_client
	end

end
