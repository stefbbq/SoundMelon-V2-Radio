class ArtistUpload < ActiveRecord::Base
  attr_accessible :song_id, :keywords, :active, :upload_source, :song_url, :is_private
	belongs_to :artist
end
