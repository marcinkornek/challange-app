class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  # :recoverable, :rememberable and :trackable
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :login # adds getter & setter :crop_x.. etc (necessary when undefined method error)
  after_update :crop_avatar

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  if Rails.env.production?
    devise  :database_authenticatable,
            :registerable,
            :validatable,
            :confirmable,
            :recoverable,
            :rememberable,
            :omniauthable,
            :omniauth_providers => [:facebook, :github, :google_oauth2]
  else
    devise  :database_authenticatable,
            :async,
            :registerable,
            :validatable,
            :confirmable,
            :recoverable,
            :rememberable,
            :omniauthable,
            :omniauth_providers => [:facebook, :github, :google_oauth2]
  end

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
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
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
      username = auth.extra.raw_info.name.gsub(/ /,'_').downcase  #gsub(changes regex / / into '_')
    end
  end

  def crop_avatar
    if crop_x.present?
      avatar.recreate_versions!
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # Overridden to notify users with password changes
  def update_with_password(params, *options)
    if super
      # TODO schedule this in the background
      UserMailer.password_changed(self.id).deliver
    end
  end

  # def crop_x => attr_reader - getter
  # def crop_x + def crop_x=(newv) => attr_accessor - getter + setter

  # def crop_x
  #   @crop_x
  # end

  # def crop_x=(newv)
  #   @crop_x = newv
  # end

end
