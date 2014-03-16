class AddYoutubeTokenToArtists < ActiveRecord::Migration
  def change
		add_column :artists, :youtube_token, :string
  end
end
