class AddSongHistoryToUsers < ActiveRecord::Migration
  def change
		add_column :users, :song_history, :text
  end
end
