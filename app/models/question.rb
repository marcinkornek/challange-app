class Question < ActiveRecord::Base
  belongs_to :accepted_answer, class_name: "Answer"
  belongs_to :user
  has_many :answers, dependent: :destroy

  default_scope -> { order('created_at DESC') }

  before_create :decrement_points
  validate :validate_points, on: :create
  # before_update :

  validates :title,         presence: true,
                            length: { maximum: 60 }
  validates :contents,      presence: true
  validates :user_id,       presence: true

  # def create_with_points

  # end

  def decrement_points
    user.points -= 10
    user.save
  end

  def validate_points
    if user.points < 10
      errors.add(:base, 'you dont have enough points')
    end
  end

end
