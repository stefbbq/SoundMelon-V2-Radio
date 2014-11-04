class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  respond_to :js, :json, :html, :xml

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @is_omni = true
    @email = request.env["omniauth.auth"].info.email
    @email_user = User.find_by_email(@email)
    # logger.debug request.env["omniauth.auth"].info.email
    if @email_user && (@email_user.uid.nil? || @email_user.uid == '')
      #check if user exists as email signup
      @is_omni = false
      logger.debug "User exists"
      respond_to do |format|
        format.js
      end      

    else

      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in @user, :event => :authentication, resource: @user
        respond_to do |format|
          format.js
        end
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end

    end

  end

end