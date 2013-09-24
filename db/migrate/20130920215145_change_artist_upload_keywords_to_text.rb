class ChangeArtistUploadKeywordsToText < ActiveRecord::Migration
  def up
		change_column :artist_uploads, :keywords, :text
  end

  def down
  end
end
