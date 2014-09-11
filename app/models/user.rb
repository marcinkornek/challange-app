class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  # :recoverable, :rememberable and :trackable
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  devise :database_authenticatable, :registerable, :validatable, :confirmable, :recoverable#, :rememberable

  mount_uploader :avatar, AvatarUploader

  VALID_USERNAME_REGEX = /\A[a-z]\w*\z/i
  validates :username,  presence: true,
                        length: { in: 4..16 },
                        uniqueness: { case_sensitive: false },
                        format: { with: VALID_USERNAME_REGEX }
  validates_numericality_of :points, greater_than_or_equal_to: 0

  def to_s
    email
  end

end
