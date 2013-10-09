class Feedback < ActiveRecord::Base
	attr_accessible :email, :title, :content

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, :presence => true, :length => {:maximum => 25}, format: { with: VALID_EMAIL_REGEX }

end
