module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user 	#makes the variable 'current_user' 
														 	#available in all views and controllers
		if current_user.is_artist?
			self.current_artist = Artist.find(current_user.artist_id)
		end
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

	def current_artist=(artist)
    @current_artist = artist
  end
  
  def current_artist
		if current_user.is_artist?
    	@current_artist ||= Artist.find_by_id(current_user.artist_id)
  	end
	end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

end
