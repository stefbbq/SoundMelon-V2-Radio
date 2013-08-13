class RenameArtistUploadsSongId < ActiveRecord::Migration
  def up
		rename_column :artist_uploads, :song_item, :song_id
  end

  def down
  end
end
