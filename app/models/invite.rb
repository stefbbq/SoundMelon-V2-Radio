class Invite < ActiveRecord::Base
	attr_accessible :email, :status
	before_create :generate_token

	protected

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, :presence => true, :length => {:maximum => 25}, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
#	validate :email_not_used

#	def email_not_used
#		if User.exists?(email: self.email)
#			errors.add(:email, "This email address is already associated with a Soundmelon account!")
#		end
#	end

	def generate_token
		self.token = loop do
			random_token = SecureRandom.urlsafe_base64(nil, false)
			break random_token unless Invite.exists?(token: random_token)
		end
	end

end
