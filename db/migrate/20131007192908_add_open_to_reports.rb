class AddOpenToReports < ActiveRecord::Migration
  def change
		add_column :reports, :open, :boolean, default: true
  end
end
