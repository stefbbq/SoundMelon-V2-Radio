require 'rubygems'
require 'faraday'	

module ArtistsHelper

	def yt_auth_ids
		# Return a hash that initializes youtube authentication relevant parameters 
		ids = {client_id: '1035080270379-o8mnqtq490m1v2v1btgjfl1o54u3v0b3.apps.googleusercontent.com',
					 client_secret: '-mEtRYHzGaAqa-035VdwtdiK',
					 redirect_uri: $localtunnel_add + '/yt_oauth_callback',
					 yt_scope: 'https://gdata.youtube.com',
					 dev_key: 'AI39si4xwZsnYS8ZPjdY36jy8jGCyBxCavTy1Xj_P5DtaCibNDzilGmeCLRPD9mTz0mHoPhm9LlF2REKzq5ivQQGLRe4g8uqHg'
					}
		return ids
	end

	def sc_auth_ids
		ids = {client_id: 'aed36f8bf087fe7716c9e594a211e8fb',
					 client_secret: 'dfd9ce380afd86f81619ad1b1dca8d72',
					 redirect_uri: $localtunnel_add + '/sc_oauth_callback'}
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

end
