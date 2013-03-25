class User < ActiveRecord::Base
	attr_accessible :first_name, :last_name, :username, :email
	
	before_save { |user| user.email = email.downcase }
	
	validates :first_name, :presence => true, :length => {:maximum => 25}
	validates :last_name, :length => {:maximum => 30}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, :presence => true, :length => {:maximum => 25}, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
	validates :username, :presence => true, :length => {:minimum =>8, :maximum => 16}
end
