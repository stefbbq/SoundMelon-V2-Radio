class AddUrlToSongs < ActiveRecord::Migration
  def change
		add_column :songs, :song_url, :string
  end
end
