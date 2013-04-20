class UsersController < ApplicationController
	respond_to :js, :json, :html, :xml

	def show
		@user = User.find_by_email(params[:email])
	end

  def new
		@user = User.new
  end

	def create
    @user = User.new(params[:user])
    if @user.save
			respond_with @user
    else
      render 'new'
    end
  end

end
