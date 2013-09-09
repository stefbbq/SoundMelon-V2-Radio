class AddCustomCityToUsers < ActiveRecord::Migration
  def change
		add_column :users, :custom_city, :boolean, :default => false
		#City different from OmniAuth location
  end
end
