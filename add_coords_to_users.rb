require 'geocoder'

users = User.all
users.each do |user|
	coords = nil
	coords = Geocoder.coordinates(user.city).join(",") if (!user.city.nil? && user.city != '')
	user.update_column(:city_coords, coords)
	puts coords
	sleep(1)
	# if !user.city.nil? && user.city != ''
	# 	coords = Geocoder.coordinates(user.city).join(",")
		
	# end
end

artists = Artist.all
artists.each do |artist|
	coords = nil
	coords = Geocoder.coordinates(artist.city).join(",") if (!artist.city.nil? && artist.city != '')
	artist.update_column(:city_coords, coords)
	puts coords
	sleep(0.5)
	# if !user.city.nil? && user.city != ''
	# 	coords = Geocoder.coordinates(user.city).join(",")
		
	# end
end

# artists = Artist.all
# artists.each do |artist|
# 	if !artist.city.nil? && artist.city != ''
# 		coords = Geocoder.coordinates(artist.city).join(",")
# 		artist.update_column(:city_coords, coords)
# 	end
# end