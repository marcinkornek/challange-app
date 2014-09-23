class Notification < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :answer_id, presence: true
  validates :notification, presence: true
end
