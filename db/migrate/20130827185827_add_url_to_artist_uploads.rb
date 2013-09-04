class AddUrlToArtistUploads < ActiveRecord::Migration
  def change
		add_column :artist_uploads, :song_url, :string
  end
end
