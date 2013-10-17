class AddBlockedToSongs < ActiveRecord::Migration
  def change
		add_column :songs, :blocked, :boolean, default: false
  end
end
