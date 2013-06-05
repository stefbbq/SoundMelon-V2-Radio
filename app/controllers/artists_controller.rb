class ArtistsController < ApplicationController
	include ArtistsHelper

	@client_id = '1035080270379-o8mnqtq490m1v2v1btgjfl1o54u3v0b3.apps.googleusercontent.com'
	@client_secret = '-mEtRYHzGaAqa-035VdwtdiK'
	@redirect_uri = $localtunnel_add + '/oauth_callback'
	@yt_scope = 'https://gdata.youtube.com'
	@dev_key = 'AI39si4NdoFr4M6V-z859EWcMfSD7NWZIcP7Wjyf4YahZCcwHreX_bselRsxm00SXP9032quuPI4AHSa3siqh1J6dGuEk9mzow'

	def oauth_setup
		conn = Faraday.new(:url => 'https://accounts.google.com',:ssl => {:verify => false}) do |faraday|
		 faraday.request  :url_encoded
		 faraday.response :logger
		 faraday.adapter  Faraday.default_adapter
		end
		return conn
	end

	def obtain_token(conn, client_token, grant_type)
		
		result = conn.post '/o/oauth2/token', {code: client_token,
																					client_id: @client_id,
																					 client_secret: @client_secret,
																					 redirect_uri: @redirect_uri,
																					 grant_type: grant_type}
		return result
	end

	def create
		@artist = Artist.new(artist_name: current_user.username, user_id: current_user.id)
		@artist.save
		current_user.update_column(:artist_id, @artist.id)
	end

	def oauth_callback
	
		conn = oauth_setup
		@client_token = params[:code]
		@result = obtain_token(conn, @client_token, 'authorization_code')

		@new_tokens = JSON.load(@result.body)
#		if @new_tokens.has_key?('error')
#			#do something
#			flash[:failure] = 'Sorry, did not work!'		
#		else
#			create
#			current_artist.update_column(:youtube_token, new_tokens["access_token"])
#			#client = YouTubeIt::OAuth2Client.new(client_access_token: new_tokens["access_token"], client_id: @client_id, client_secret: @client_secret, dev_key: @dev_key)
#			redirect_to current_user
#		end
	end

	def current_artist=(artist)
    @current_artist = artist
  end
  
  def current_artist
		if is_artist?
    	@current_artist ||= Artist.find_by_id(current_user.artist_id)
  	end
	end





end
