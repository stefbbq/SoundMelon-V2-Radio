class Artist < ActiveRecord::Base
  attr_accessible :artist_name
	belongs_to :user
end
