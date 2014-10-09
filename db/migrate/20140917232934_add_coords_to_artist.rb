class AddCoordsToArtist < ActiveRecord::Migration
  def change
  	add_column :artists, :city_coords, :text
  end
end
