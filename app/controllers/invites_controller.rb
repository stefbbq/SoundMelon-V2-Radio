class InvitesController < ApplicationController
	include ApplicationHelper
	respond_to :js, :json, :html, :xml

	def create
		@email = params[:invite][:email]
		@formatted = validate_email(@email)
		@in_db = User.exists?(email: @email) || Invite.exists?(email: @email)
		flash[:error] = nil
		if @formatted && !@in_db
			@user = User.find(params[:invite][:user_id])
			@invite = Invite.new(params[:invite].except(:user_id))
			@invite.save
			@user.invites = @user.invites.nil? ? [@email] : @user.invites << @email
			@user.save
			UserMailer.invite_message(@email, @user, @invite.token).deliver
		elsif !@formatted
			write_flash('error', 'Invalid email address')
		elsif @in_db
			write_flash('warning', 'This email address already exists in our records.')
		end
	end

end
