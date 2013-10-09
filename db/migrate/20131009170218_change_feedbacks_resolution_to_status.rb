class ChangeFeedbacksResolutionToStatus < ActiveRecord::Migration
  def up
		rename_column :feedbacks, :resolution, :status
  end

  def down
  end
end
