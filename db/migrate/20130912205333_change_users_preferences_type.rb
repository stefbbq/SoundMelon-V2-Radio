class ChangeUsersPreferencesType < ActiveRecord::Migration
  def up
		change_column :users, :preferences, :text
  end

  def down
  end
end
