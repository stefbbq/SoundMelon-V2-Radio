class AddSongImageToSongs < ActiveRecord::Migration
  def change
		add_column :songs, :song_image, :string
  end
end
