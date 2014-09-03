class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers

  validates :title, presence: true
  validates :contents, presence: true
  validates :user_id, presence: true

end
