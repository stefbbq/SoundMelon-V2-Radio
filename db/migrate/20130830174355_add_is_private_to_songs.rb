class AddIsPrivateToSongs < ActiveRecord::Migration
  def change
		add_column :songs, :is_private, :bool
  end
end
