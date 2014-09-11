class AddArtistFlagsToArtists < ActiveRecord::Migration
  def change
  	add_column :artists, :first_song_added, :boolean, default: false
  	add_column :artists, :profile_edited, :boolean, default: false
  end
end
