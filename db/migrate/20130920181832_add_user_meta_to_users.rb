class AddUserMetaToUsers < ActiveRecord::Migration
  def change
		add_column :users, :user_meta, :text
  end
end
