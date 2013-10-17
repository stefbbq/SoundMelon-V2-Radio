class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
			t.references :artist
			t.string :song_item
			t.string :keywords
			t.boolean :active, default: true
      t.timestamps
    end
  end

end
