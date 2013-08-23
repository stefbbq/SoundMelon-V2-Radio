class ChangeArtistTokensToText < ActiveRecord::Migration
  def up
		change_column :artists, :youtube_token, :text
		change_column :artists, :soundcloud_token, :text
  end

  def down
  end
end
