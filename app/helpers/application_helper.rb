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

	def new_yt_client(yt_ids, yt_tokens)
		# Initialize and return a new youtube_it client
		client = YouTubeIt::OAuth2Client.new(client_access_token: yt_tokens[:access_token],
																					client_refresh_token: yt_tokens[:refresh_token],
																					client_id: yt_ids[:client_id],
																					client_secret: yt_ids[:client_secret],
																					dev_key: yt_ids[:dev_key],
																					client_token_expires_at: yt_tokens[:expires_at])
		return client
	end

	def refresh_yt_client(yt_client)
		yt_tokens = current_artist.youtube_tokens
		yt_client.refresh_access_token!
		yt_tokens[:access_token] = yt_client.access_token.token
		yt_tokens[:expires_at] = yt_client.access_token.expires_at
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

	def echonest_init
		wrap = Echonest
		wrap.configure do |config|
				config.api_key = ENV['ECHONEST_API_KEY']
				config.consumer_key = ENV['ECHONEST_CONSUMER_KEY']
				config.shared_secret = ENV['ECHONEST_SHARED_SECRET']
		end
		return wrap
	end

	def update_count_hash(my_hash, key)
		if my_hash.has_key?(key)
			my_hash[key] += 1
		else
			my_hash[key] = 1
		end
		return my_hash
	end

end
