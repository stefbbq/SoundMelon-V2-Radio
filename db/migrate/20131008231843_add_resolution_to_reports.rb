class AddResolutionToReports < ActiveRecord::Migration
  def change
		add_column :reports, :resoultion, :string
  end
end
