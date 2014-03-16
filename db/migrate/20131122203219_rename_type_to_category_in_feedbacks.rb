class RenameTypeToCategoryInFeedbacks < ActiveRecord::Migration
  def up
		rename_column :feedbacks, :type, :category
  end

  def down
  end
end
