class AddRememberableToDevise < ActiveRecord::Migration
  def change
    ## Rememberable
    add_column :users, :remember_created_at, :datetime
  end
end
