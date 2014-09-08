class Question < ActiveRecord::Base
  belongs_to :accepted_answer, class_name: "Answer"
  belongs_to :user
  has_many :answers, dependent: :destroy


  default_scope -> { order('created_at DESC') }

  validates :title,         presence: true,
                            length: { maximum: 60 }
  validates :contents,      presence: true
  validates :user_id,       presence: true

end
