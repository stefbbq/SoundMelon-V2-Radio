class AddSoundCloudTokenToArtists < ActiveRecord::Migration
  def change
		add_column :artists, :soundcloud_token, :string
  end
end
