class AddTokenToInvites < ActiveRecord::Migration
  def change
		add_column :invites, :token, :text
  end
end
