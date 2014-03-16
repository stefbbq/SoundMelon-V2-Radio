class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
			t.string :email
			t.string :title
			t.text :content
			t.boolean :open
			t.string :resolution
      t.timestamps
    end
  end
end
