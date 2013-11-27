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
		flash[:account_updated] = true
	end

	def create
    @user = User.new(params[:user])
    if @user.save
			respond_with @user
    else
      render 'new'
    end
  end

	def edit_meta
	end

	def update_user_meta
		params[:user][:user_meta] = params[:user][:user_meta].split(',')
		update_attrs(params)
		flash[:meta_updated] = true
	end

	def update_fb_meta
		@user = User.find(params[:user][:id])
		@current_fb_meta = @user.fb_meta
		@new_fb_meta = params[:user][:fb_meta].split(',')
		
		@removed_fb_meta = @current_fb_meta.keys - @new_fb_meta
		@new_fb_meta_hash = @current_fb_meta.except(*@removed_fb_meta)
		
		@added_fb_meta_lst = @new_fb_meta - @current_fb_meta.keys
		@added_fb_meta_lst.each do |item|
			@new_fb_meta_hash = update_count_hash(@new_fb_meta_hash, item)
		end
		params[:user][:fb_meta] = @new_fb_meta_hash
		@user.update_attributes(params[:user])
	end

	def accept_terms
		update_attrs(params)
	end

	def init_fb_meta
		@user = User.find_by_id(params[:user][:id])
		@user_genres = collect_genres(@user)
		params[:user][:fb_meta] = @user_genres
		update_attrs(params)
	end

	def reload_fb_meta
		@user = User.find_by_id(params[:id])
		@user_genres = collect_genres(@user)
		@user.update_attributes(fb_meta: @user_genres)
	end
	
	def new_invites
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
