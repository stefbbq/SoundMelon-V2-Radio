class AddTermsToUsers < ActiveRecord::Migration
  def change
		add_column :users, :terms, :boolean, :default => false
		#True means accepted terms and conditions
  end
end
