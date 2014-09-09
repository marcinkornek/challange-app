class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_one :opinion, as: :opinionable

  validates :contents, presence: true
  validates :user_id, presence: true
  validates :question_id, presence: true

end
