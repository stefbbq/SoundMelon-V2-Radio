class RenameResolutionInReports < ActiveRecord::Migration
  def up
		rename_column :reports, :resoultion, :resolution
  end

  def down
  end
end
