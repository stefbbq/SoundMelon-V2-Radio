class UsersController < ApplicationController
	include UsersHelper

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

	def update
	end

	def accept_terms
		update_attrs(params)
	end

	def update_prefs
		update_attrs(params)
	end

	def update_attrs(params)
		@user = User.find_by_id(params[:user][:id])
		@user.update_attributes(params[:user])
	end

end
