class ArtistUpload < ActiveRecord::Base
  attr_accessible :song_id, :keywords, :active, :upload_source
	belongs_to :artist
end
