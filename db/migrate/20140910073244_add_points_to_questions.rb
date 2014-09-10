class AddPointsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :points, :integer, default: 0
  end
end
