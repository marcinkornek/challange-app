class AddSendNewMessageEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :send_new_message_email, :boolean, default: true
  end
end
