class ArtistUpload < ActiveRecord::Base
  attr_accessible :song_id, :keywords, :active, :upload_source, :song_url, :is_private
	serialize :keywords
	belongs_to :artist
end
