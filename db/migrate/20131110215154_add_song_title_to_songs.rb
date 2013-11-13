class AddSongTitleToSongs < ActiveRecord::Migration
  def change
		add_column :songs, :song_title, :string
  end
end
