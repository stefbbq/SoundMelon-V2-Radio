class UsersController < ApplicationController
	include UsersHelper, ApplicationHelper

	respond_to :js, :json, :html, :xml

	def show
		@user = User.find_by_email(params[:email])
	end

  def new
		@user = User.new
  end

	def edit
	end

	def edit_account
	end

	def update_account
		@parameters = params
		update_attrs(params)
	end

	def create
    @user = User.new(params[:user])
    if @user.save
			respond_with @user
    else
      render 'new'
    end
  end

	def edit_prefs
	end

	def update_prefs
		@user = User.find_by_id(params[:user][:id])
		@current_prefs = @user.preferences
		@new_prefs = params[:user][:preferences].split(',')
		@removed_prefs = @current_prefs.keys - @new_prefs
		@added_prefs = @new_prefs - @current_prefs.keys
		@new_pref_hash = @current_prefs.except(*@removed_prefs)
		@added_prefs.each do |pref|
			update_count_hash(@new_pref_hash, pref)
		end
		params[:user][:preferences] = @new_pref_hash
		update_attrs(params)
	end

	def accept_terms
		update_attrs(params)
	end

	def init_prefs
		@user_genres = collect_genres
		params[:user][:preferences] = @user_genres
		update_attrs(params)
	end

	def update_attrs(params)
		@user = User.find_by_id(params[:user][:id])
		@user.update_attributes(params[:user])
	end

	def destroy
		User.find(params[:id]).destroy
		redirect_to signout_path
	end

end
