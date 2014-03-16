class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
			t.string :artist_name
			t.references :user
      t.timestamps
    end
  end
end
