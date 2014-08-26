class AddSocialLinksToArtists < ActiveRecord::Migration
  def change
  	add_column :artists, :facebook_link, :text
  	add_column :artists, :twitter_link, :text
  end
end
