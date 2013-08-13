class ArtistUpload < ActiveRecord::Base
  attr_accessible :song_id, :keywords, :active
	belongs_to :artist
end
