class Feedback < ActiveRecord::Base
	attr_accessible :email, :title, :content, :category

end
