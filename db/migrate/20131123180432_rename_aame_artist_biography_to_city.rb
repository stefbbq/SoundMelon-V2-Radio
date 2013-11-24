class RenameAameArtistBiographyToCity < ActiveRecord::Migration
  def up
		remove_column :artists, :biography
		add_column :artists, :city, :string
  end

  def down
  end
end
