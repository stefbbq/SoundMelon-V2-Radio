class AddFavoriteSongsToUsers < ActiveRecord::Migration
  def change
		add_column :users, :favorite_songs, :text
  end
end
