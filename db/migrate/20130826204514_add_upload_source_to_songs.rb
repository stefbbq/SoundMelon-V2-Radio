class AddUploadSourceToSongs < ActiveRecord::Migration
  def change
		add_column :songs, :upload_source, :string
  end
end
