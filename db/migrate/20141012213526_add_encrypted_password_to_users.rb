class AddEncryptedPasswordToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :encrypted_password, :string# t.string :encrypted_password, null: false, default: ""
  end
end
