class AddCoordsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :city_coords, :text
  end
end
