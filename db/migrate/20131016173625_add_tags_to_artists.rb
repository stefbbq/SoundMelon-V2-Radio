class AddTagsToArtists < ActiveRecord::Migration
  def change
		add_column :artists, :genre_tags, :text
  end
end
