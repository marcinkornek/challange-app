class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title,         presence: true,
                            length: { maximum: 60 }
  validates :contents,      presence: true
  validates :user_id,       presence: true

end
