class AddQuestionIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :question_id, :integer
  end
end
