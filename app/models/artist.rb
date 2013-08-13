class Artist < ActiveRecord::Base
  attr_accessible :artist_name, :youtube_token
	belongs_to :user
	has_many :artist_upload
	serialize :youtube_token
end
