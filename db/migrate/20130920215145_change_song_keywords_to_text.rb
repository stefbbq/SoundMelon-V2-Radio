class ChangeSongKeywordsToText < ActiveRecord::Migration
  def up
		change_column :songs, :keywords, :text
  end

  def down
  end
end
