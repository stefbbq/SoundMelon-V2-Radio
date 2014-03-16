class AddArtistProfileFields < ActiveRecord::Migration
  def up
		add_attachment :artists, :artist_photo
		add_column :artists, :website, :string
		add_column :artists, :biography, :text
  end

  def down
  end
end
