class AddArtistToUsers < ActiveRecord::Migration
  def change
		add_column :users, :is_artist, :boolean, default: false
		add_column :users, :artist_id, :integer, references: 'artists'
  end
end
