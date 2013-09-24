SoundMelonV2Radio::Application.routes.draw do
  resources :users
	resources :sessions, only: [:new, :create, :destroy]
	resources :artist_uploads
  
  root to: 'welcome#index'
  
#  match '/signup', to: 'users#new'
#	match '/signin',  to: 'sessions#new'
	match '/auth/:provider/callback', :to => 'sessions#create'
	match '/auth/failure', :to => redirect('/')
  match '/signout', to: 'sessions#destroy'
	match '/accept_terms', to: 'users#accept_terms'
	match '/init_fb_meta', to: 'users#init_fb_meta'
	match '/user_meta', to: 'users#edit_meta'
	match '/update_fb_meta', to: 'users#update_fb_meta'
	match '/update_user_meta', to: 'users#update_user_meta'
	match '/user_account', to: 'users#edit_account'
	match '/update_account', to: 'users#update_account'
	match '/add_media_account', to: 'users#add_media_account'
	match '/new_upload', to: 'artist_uploads#new'
	match '/edit_upload', to: 'artist_uploads#edit'
	match '/sc_request', to: 'artists#sc_request'
	match '/sc_oauth_callback', to: 'artists#sc_oauth_callback'
	match '/yt_request', to: 'artists#yt_request'
	match '/yt_oauth_callback', to: 'artists#yt_oauth_callback'
	match '/artist_show', to: 'artists#show'
#	match '/sc_show', to: 'artists#sc_show'
	match '/make_public', to: 'artist_uploads#make_public'
	match '/request_playlist', to: 'artist_uploads#request_playlist'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
