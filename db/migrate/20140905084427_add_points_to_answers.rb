class AddPointsToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :points, :integer, default: 0
  end
end
