class AddIsPrivateToArtistUploads < ActiveRecord::Migration
  def change
		add_column :artist_uploads, :is_private, :bool
  end
end
