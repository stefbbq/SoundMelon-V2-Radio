class AddInvitesToUsers < ActiveRecord::Migration
  def change
		add_column :users, :invites, :text
  end
end
