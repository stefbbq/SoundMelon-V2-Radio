class UsersController < ApplicationController
	include UsersHelper, ApplicationHelper

	respond_to :js, :json, :html, :xml

	def show
		@user = User.find_by_email(params[:email])
	end

  def new
		@user = User.new
  end

  def email_signup

  end

  def checkin
  	@user = User.find_by_email(params[:user][:email])
  	@exists = !@user.nil?
  	@fb_user = false
  	@success = false
		if @exists && @user.valid_password?(params[:user][:password])
			@success = true
			sign_in(:user, @user)
		elsif @exists && @user.uid
			@fb_user = true
		elsif !@exists
			@redirection = new_user_registration_url(locals: params)
		end
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
		write_flash('notification', 'Your Likes have been updated!')
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
		write_flash('notification', 'Your Likes have been updated!')
	end

	def accept_terms
		update_attrs(params)
	end

	def init_fb_meta
		@user = User.find_by_id(params[:user][:id])
		@user_genres = collect_genres(@user)
		params[:user][:fb_meta] = @user_genres
		@user.update_attributes(params[:user])
		# @all_genres = params[:user][:fb_meta]
		# update_attrs(params)
		# @user.update_attributes(fb_meta: @user_genres)
	end

	def add_city
		@user = User.find_by_id(params[:user][:id])
		if params[:user][:user_meta]
			params[:user][:user_meta] = params[:user][:user_meta].split(',')
		end
		update_attrs(params)
		@user.update_column(:city_coords, Geocoder.coordinates(params[:user][:city]).join(','))
	end

	def search_cities
		@address = params[:address]
		@cities = Geocoder.search(@address)
		limit = 5
		@json = {}
		i = 0
		@cities.each do |city|
			if i == limit
				break
			end
			# if city.types.include? 'locality'
			# 	@json[i] = city.data
			# 	i += 1
			# end
			@json[i] = city.data
			i += 1
		end
		respond_to do |format|
			format.json {render json: @json.to_json}
			format.js
		end
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
	
	def add_media_account
	end

	def add_favorite
		@user = User.find_by_id(current_user.id)
		@song = Song.find_by_song_id(params[:song_id])
		@favorites = @user.favorite_songs.nil? || @user.favorite_songs.size == 0 ? [] : @user.favorite_songs
		if !@favorites.include?(@song.song_id)
			@favorites << @song.song_id
		else
			@favorites.delete(@song.song_id)
		end
		@user.update_attributes({favorite_songs: @favorites})
		@favorites = @user.favorite_songs
	end

	def show_favorites
		@user = User.find(current_user.id)
		@favorites = @user.favorite_songs
		if !@favorites.nil?
			@favorites.each do |song|
				obj = Song.find_by_song_id(song)
				if obj.nil? || !obj.active
					@favorites.delete(song)
				end
			end
		end
		@user.update_attributes({favorite_songs: @favorites})
	end

	def update_favorites
		@new_list = params[:favorites]
		@user = User.find(current_user.id)
		@user.update_attributes({favorite_songs: @new_list})
	end

	def destroy
		User.find(params[:id]).destroy
		redirect_to destroy_user_session_path
	end

end
