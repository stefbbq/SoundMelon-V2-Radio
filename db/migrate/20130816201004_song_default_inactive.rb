class SongDefaultInactive < ActiveRecord::Migration
  def up
		change_column :songs, :active, :boolean, default: false
  end

  def down
  end
end
