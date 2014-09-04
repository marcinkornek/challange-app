class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  # :recoverable, :rememberable and :trackable
  devise :database_authenticatable, :registerable, :validatable #, :comfirmable, :recoverable, :rememberable

  mount_uploader :avatar, AvatarUploader

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,  format: { with: VALID_EMAIL_REGEX }

  has_many :questions
  has_many :answers

  def to_s
    email
  end
end
