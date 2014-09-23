class AddFriendlyTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :friendly_token, :boolean, default: false
  end
end
