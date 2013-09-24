class ChangeUserPreferencesToFacebookMeta < ActiveRecord::Migration
  def up
		rename_column :users, :preferences, :fb_meta
  end

  def down
  end
end
