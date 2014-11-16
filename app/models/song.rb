class Song < ActiveRecord::Base
  attr_accessible :song_id, :active, :upload_source, :song_url, :is_private, :sm_tags, :source_tags, :song_title, :duration, :song_image, :slug
	serialize :sm_tags
	serialize :source_tags

	extend FriendlyId
	friendly_id :song_title, use: :slugged

	belongs_to :artist
end
