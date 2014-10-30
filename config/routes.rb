SoundMelonV2Radio::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # devise_for :users
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations", passwords: "users/passwords", sessions: "users/sessions" }

  devise_scope :user do
    match '/signout', :to => 'devise/sessions#destroy', :as => :destroy_user_session

    #User routes
    match '/user/:id', to: 'users#show'
    match '/user_checkin', to: 'users#checkin'
    match '/email_signup', to: 'users#email_signup'
    match '/accept_terms', to: 'users#accept_terms'
    match '/init_fb_meta', to: 'users#init_fb_meta'
    match '/search_cities', to: 'users#search_cities'
    match '/add_city', to: 'users#add_city'
    match '/reload_fb_meta', to: 'users#reload_fb_meta'
    match '/update_user_meta', to: 'users#update_user_meta'
    match '/update_fb_meta', to: 'users#update_fb_meta'
    match '/add_favorite', to: 'users#add_favorite'
    match '/show_favorites', to: 'users#show_favorites'
    match '/update_favorites', to: 'users#update_favorites'
    match '/user_account', to: 'users#edit_account'
    match '/update_account', to: 'users#update_account'
    match '/add_media_account', to: 'users#add_media_account'
    match '/user_invites', to: 'users#new_invites'
    match '/user_remove', to: 'users#destroy'
  end

	resources :songs
  
  root to: 'welcome#index'

  match '/about', to: redirect('http://about.soundmelon.com')

#Admin routes
#	post 'send_mass_email' => 'users#send_mass_email'

#Report routes
	match '/report_song', to: 'reports#report_song'
	match '/send_report', to: 'reports#send_report'

#Feedback routes
	match '/feedback_form', to: 'feedbacks#new'
	match '/feedback_send', to: 'feedbacks#create'

#Artist routes
	match '/sc_request', to: 'artists#sc_request'
	match '/sc_oauth_callback', to: 'artists#sc_oauth_callback'
	match '/yt_request', to: 'artists#yt_request'
	match '/yt_oauth_callback', to: 'artists#yt_oauth_callback'
	match '/artist_show', to: 'artists#show'
	match '/artist_profile_update', to: 'artists#profile_update'
	match '/request_unlink', to: 'artists#request_unlink'
	match '/unlink_media_account', to: 'artists#unlink_media_account'
	match '/artist_profile_edit', to: 'artists#profile_edit'
	match '/artist_info', to: 'artists#show_artist_info'

#Song routes
	match '/make_public', to: 'songs#make_public'
	match '/request_playlist', to: 'songs#request_playlist'
  match '/request_history_reset', to: 'songs#history_reset'
	match '/get_source_tags', to: 'songs#get_source_tags'
	match '/new_song', to: 'songs#new'
	match '/edit_song', to: 'songs#edit'

	
#Invite routes
	match '/send_invite' => 'invites#create'
	match "/:invite_token", to: redirect('/')

end
