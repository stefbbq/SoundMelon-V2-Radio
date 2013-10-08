module UsersHelper

	def is_artist?
		return current_user.is_artist
	end

	def collect_genres(user)
		graph = Koala::Facebook::API.new(user.oauth_token.token)
		music_query = "SELECT name, type FROM page WHERE page_id IN (SELECT page_id FROM page_fan WHERE uid=me() AND profile_section='music')"
		likes = graph.fql_query(music_query)
		user_genres = {}
		echowrap = echonest_init
		error_message = []
		likes.each do |like|
			if like["type"].include? "GENRE"
				user_genres = update_count_hash(user_genres, like["name"].downcase)
			else
				begin
					artist_tags = echowrap.artist_terms(name: like["name"])
					artist_tags.each do |tag|
						user_genres = update_count_hash(user_genres, tag.name.downcase)
					end
				rescue
					error_message << "#{$!}"
				end
			end
		end
		return user_genres
	end

end
