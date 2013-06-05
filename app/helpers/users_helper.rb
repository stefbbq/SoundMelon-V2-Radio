module UsersHelper

	def is_artist?
		return current_user.is_artist
	end

end
