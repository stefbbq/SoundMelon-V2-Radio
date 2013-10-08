class AddBlockedToArtistUploads < ActiveRecord::Migration
  def change
		add_column :artist_uploads, :blocked, :boolean, default: false
  end
end
