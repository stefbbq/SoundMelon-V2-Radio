class ArtistsUploads < ActiveRecord::Migration
  def up
		create_table :artists_uploads do |t|
			t.references :artist
			#t.string :song_title
			t.string :genres
			t.boolean :active, default: true
		end
  end

  def down
		drop_table :astists_uploads
  end
end
