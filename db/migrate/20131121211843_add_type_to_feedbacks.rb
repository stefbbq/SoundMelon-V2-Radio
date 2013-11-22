class AddTypeToFeedbacks < ActiveRecord::Migration
  def change
		add_column :feedbacks, :type, :string
  end
end
