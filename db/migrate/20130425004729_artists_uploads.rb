class ArtistsUploads < ActiveRecord::Migration
  def up
		create_table :artists_songs do |t|
			t.references :artist
			#t.string :song_title
			t.string :keywords
			t.boolean :active, default: true
		end
  end

  def down
		drop_table :astists_songs
  end
end
