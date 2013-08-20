class ArtistUploadDefaultInactive < ActiveRecord::Migration
  def up
		change_column :artist_uploads, :active, :boolean, default: false
  end

  def down
  end
end
