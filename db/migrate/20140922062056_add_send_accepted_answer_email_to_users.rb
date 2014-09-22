class AddSendAcceptedAnswerEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :send_accepted_answer_email, :boolean, default: true
  end
end
