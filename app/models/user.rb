class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]
  
  # Relationship setup
  has_many :user_location_tags
  has_many :location_tags, through: :user_location_tags

  has_many :user_profession_tags
  has_many :profession_tags, through: :user_profession_tags


  attr_writer :login

         
  validates :username, presence: true, uniqueness: { case_sensitive: false }    
  # Validation: only allow letters, numbers, underscores, and dots in the username
  validates_format_of :username, with: /\A[a-zA-Z0-9_.]+\z/, message: "can only contain letters, numbers, underscores, and dots"
  
  # check if the same email as the username already exists in the database:
  validate :validate_username
  

  # To allow case-insensitive username
  before_save :downcase_username

  # Virtual login attribute that allows users to log in using either username or email
  def login
    @login || self.username || self.email
  end

  
  # Allow login with either email or username
  
  # def self.find_for_database_authentication(warden_conditions)
  #   conditions = warden_conditions.dup
  #   login = conditions.delete(:login)
  #   where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
  # end

  # https://github.com/heartcombo/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end


  private

  # Ensure usernames are saved in lowercase
  def downcase_username
    self.username = username.downcase if username.present?
  end

  # Custom validation to ensure the username is not the same as an email in the system
  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

end