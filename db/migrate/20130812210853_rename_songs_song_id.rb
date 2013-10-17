class RenameSongsSongId < ActiveRecord::Migration
  def up
		rename_column :songs, :song_item, :song_id
  end

  def down
  end
end
