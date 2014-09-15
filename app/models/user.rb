class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  # :recoverable, :rememberable and :trackable
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  devise  :database_authenticatable,
          :registerable,
          :validatable,
          :confirmable,
          :recoverable,
          :rememberable,
          :omniauthable,
          :omniauth_providers => [:facebook]

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

  def self.search(query) #metoda jest na klasie => wywołuije się ją na klasie a nie na instancji czyli User.search
    where("username ilike ?", "%#{query}%") # ilike zamiast like => nie jest case sensitive
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      # p 'already registered with fb'
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        # p 'already registered locally'
        return registered_user
      else
        # p 'new user'
        user = User.create!(username:auth.extra.raw_info.name.gsub(/ /,'_').downcase,  #gsub(regex,'what we use to change regex for')
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20],
                          )
        user.skip_confirmation!
        user.save
        user
      end
    end
  end

end
