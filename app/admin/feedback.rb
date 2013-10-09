ActiveAdmin.register Feedback do
	actions :all, except: [:edit, :destroy]

	show do
    attributes_table do
			row :id
			row :email
			row :title
			row :content
			row :created_at
			row :updated_at
			row :open
			row :status
    end
		@issue = Feedback.find(params[:id])
		panel "" do
			if @issue.open && !(@issue.status == 'investigating')
		  	link_to("Begin Investigation", {:action => 'change_status', params: {status: 'investigating'}}, :method => :put)
			elsif @issue.open && @issue.status == 'investigating'
				link_to("Issue Resolved", {:action => 'change_status', params: {status: 'resolved'}}, :method => :put)
			else
				link_to "Re-Open", {:action => 'change_status', params: {status: 're-opened'}}, :method => :put
			end
		end
    active_admin_comments
	end

	member_action :change_status, method: :put do
		@issue = Feedback.find(params[:id])
		@status = params[:status]
		@issue.status = @status
		if @issue.status == 'resolved'
			@issue.open = false
		end
		if @issue.status == 're-opened'
			@issue.open = true
		end
		@issue.save
		redirect_to action: :show
	end

end
