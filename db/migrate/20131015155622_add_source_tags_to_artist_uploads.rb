class AddSourceTagsToArtistUploads < ActiveRecord::Migration
  def change
		rename_column :artist_uploads, :keywords, :sm_tags
		add_column :artist_uploads, :source_tags, :text
  end
end
