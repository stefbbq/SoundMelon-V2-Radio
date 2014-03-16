class UserMailer < ActionMailer::Base
	default from: 'miniflckr.mailer@gmail.com'

  def registration_confirmation(user)
		@user = user
    mail(:to => user.email, :subject => "Registered")
  end

	def admin_message(emails, subject, body)
		mail(to: emails, subject: subject, body: body)
	end

	def invite_message(email, sender, token)
		@sender = sender
		@token = token
		mail(to: email, subject: 'Invitation to Soundmelon!')
	end

	def admin_invite(email, token)
		@token = token
		mail(to: email, subject: 'Invitation to Soundmelon!')
	end

end
