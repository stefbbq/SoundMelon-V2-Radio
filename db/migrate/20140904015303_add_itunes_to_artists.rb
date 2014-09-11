class AddItunesToArtists < ActiveRecord::Migration
  def change
  	add_column :artists, :itunes_link, :text
  end
end
