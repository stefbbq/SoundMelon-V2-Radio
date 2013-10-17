class AddSourceTagsToSongs < ActiveRecord::Migration
  def change
		rename_column :songs, :keywords, :sm_tags
		add_column :songs, :source_tags, :text
  end
end
