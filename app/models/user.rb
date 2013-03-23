class User < ActiveRecord::Base
	attr_accessible :first_name, :last_name, :username, :email
	
	#validates :first_name, :presence => true, :length => {:maximum => 25}
	#validates :last_name, :length => {:maximum => 25}
	#validates :username, :presence => true, :length => {:minimum =>8, :maximum => 16}
end
