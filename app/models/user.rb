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
          :omniauth_providers => [:facebook, :github, :google_oauth2]

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

  def self.find_for_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      p '---------------------------'
      p "already registered with #{auth.provider}"
      p '---------------------------'
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        p '---------------------------'
        p 'already registered locally'
        p '---------------------------'
        return registered_user
      else
        p '---------------------------'
        p 'new user'
        p '---------------------------'
        user = User.new(username: omniauth_username(auth),
                        provider:auth.provider,
                        uid:auth.uid,
                        email:auth.info.email,
                        password:Devise.friendly_token[0,20],
                      )
        user.skip_confirmation!
        user.save
        return user
      end
    end
  end

  def self.omniauth_username(auth)
    provider = auth.provider
    if provider == 'github'
      username = auth.info.nickname
    else
      username = auth.extra.raw_info.name.gsub(/ /,'_').downcase  #gsub(regex,'what we use to change regex for')
    end
  end
end
