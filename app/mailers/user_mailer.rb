class UserMailer < ActionMailer::Base
	default from: '"miniflckr.mailer@gmail.com'

  def registration_confirmation(user)
		@user = user
    mail(:to => user.email, :subject => "Registered")
  end

	def admin_message(emails, subject, body)
		mail(to: emails, subject: subject, body: body)
	end

end
