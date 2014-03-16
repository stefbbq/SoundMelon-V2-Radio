class ChangeFeedbackColumns < ActiveRecord::Migration
  def up
		change_column :feedbacks, :open, :boolean, default: true
  end

  def down
  end
end
