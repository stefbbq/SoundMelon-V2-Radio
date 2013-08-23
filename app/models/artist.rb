class Artist < ActiveRecord::Base
  attr_accessible :artist_name, :youtube_token, :soundcloud_token
	belongs_to :user
	has_many :artist_upload
	serialize :youtube_token
	serialize :soundcloud_token
end
