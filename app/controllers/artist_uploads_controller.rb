class ArtistUploadsController < ApplicationController
	respond_to :js, :json, :html, :xml

	def new
	end

	def create
		@artist_upload = ArtistUpload.create(params[:artist_upload])
		if @artist_upload.save
			@artist_upload.update_column(:artist_id, current_artist.id)
		end
	end

	def edit
	end

end
