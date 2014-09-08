class ChangePointsToUsers < ActiveRecord::Migration
  def change
    change_column :users, :points, :integer, default: 100
  end
end
