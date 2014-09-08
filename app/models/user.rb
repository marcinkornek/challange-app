class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  # :recoverable, :rememberable and :trackable
  devise :database_authenticatable, :registerable, :validatable #, :comfirmable, :recoverable, :rememberable

  mount_uploader :avatar, AvatarUploader

  # before_save { username.downcase! }


  VALID_USERNAME_REGEX = /\A[a-z]\w*\z/i
  validates :username,  presence: true,
                        length: { in: 4..16 },
                        uniqueness: { case_sensitive: false },
                        format: { with: VALID_USERNAME_REGEX }

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  def to_s
    email
  end
end
