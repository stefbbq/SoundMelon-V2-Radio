ActiveAdmin.register User do

	index do
		selectable_column
		column :id
		column :email
		column :username
		column :first_name
		column :last_name
		column :city
		column :custom_city
		column :created_at
		column :updated_at
		column :is_artist
		column :provider
		column :terms
		actions defaults: true do |user|
			link_to "Email", {:action => 'send_email', :id => user.id}, :method => :put
		end
	end

	member_action :send_email, method: :put do
		@user = User.find(params[:id])
#		flash[:notice] = "Coulda emailed doosh #{user.email}"
#		redirect_to :action => :show
	end

	batch_action :mass_email do |selection|
		users = User.find(selection, select: 'email')
		@emails = []
		users.each do |user|
			@emails << user.email
		end
		if @emails.blank?
			redirect_to :back, flash: {error: "No users were selected!"}
		else
			render template: 'users/write_mass_email'
		end
	end

	collection_action :send_mass_email, :method => :post do
		@emails = params[:emails].split(' ')
		@subject = params[:subject]
		@body = params[:body]
		UserMailer.admin_message(@emails, @subject, @body).deliver
		flash[:notice] = @emails
		redirect_to :action => :index
	end

end
