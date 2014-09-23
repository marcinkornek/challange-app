class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :answer_id
      t.string :notification

      t.timestamps
    end
  end
end
