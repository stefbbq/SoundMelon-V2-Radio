class AddUploadSourceToArtistUploads < ActiveRecord::Migration
  def change
		add_column :artist_uploads, :upload_source, :string
  end
end
