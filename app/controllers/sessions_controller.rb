class SessionsController < ApplicationController

	def new
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
		@invite_token = params[:state]
		if !@invite_token.nil?
			if @invite_token.size > 0 && Invite.exists?(token: @invite_token)
				@invite = Invite.find_by_token(@invite_token)
				if @invite.status != 'joined'
					@invite.status = 'joined'
					@invite.save
				end
			end
		end

		if !user.terms
			# UserMailer.registration_confirmation(user).deliver
		end
    session[:user_id] = user.id
		respond_to do |format|
			format.js
		end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

end
