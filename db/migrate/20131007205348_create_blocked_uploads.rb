class CreateBlockedUploads < ActiveRecord::Migration
  def change
    create_table :blocked_uploads do |t|
			t.string :upload_source
			t.string :song_id
      t.timestamps
    end
  end
end
