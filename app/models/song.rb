class Song < ActiveRecord::Base
  attr_accessible :song_id, :active, :upload_source, :song_url, :is_private, :sm_tags, :source_tags
	serialize :sm_tags
	serialize :source_tags
	belongs_to :artist
end
