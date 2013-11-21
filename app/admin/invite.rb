ActiveAdmin.register Invite do

  action_item only: [:index] do |resource|
    link_to "Mass Invite", {:action => 'mass_invite'}, :method => :put
  end

	collection_action :mass_invite, method: :put do
	end

	collection_action :send_mass_invite, method: :post do
		email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]{2,4}+\z/i
		@emails = params[:emails].split(/,\s*/)
		@bad_emails = []
		@already_invited = []
		@emails.each do |email|
			@formatted = !email.match(email_regex).nil?
			@in_db = User.exists?(email: email) || Invite.exists?(email: email)
			if @formatted && !@in_db
				@invite = Invite.new(email: email, status: 'invited')
				@invite.save
				UserMailer.admin_invite(email, @invite.token).deliver
			elsif !@formatted
				@bad_emails << email
			elsif @in_db
				@already_invited << email
			end
		end
		@invited = Hash[@emails.map {|v| [v,v]}].except(*(@bad_emails + @already_invited))
		flash[:notice] = 'The following were invited: ' + @invited.to_s + '\n'
		flash[:notice] += 'These are invalid email addresses: ' + @bad_emails.to_s + '\n'
		flash[:notice] += 'These have been invited already' + @already_invited.to_s
		redirect_to :action => :index
	end

end
