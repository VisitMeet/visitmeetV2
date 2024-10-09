class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_writer :login

         
  validates :username, presence: true, uniqueness: { case_sensitive: false }    
  
  # To allow case-insensitive username
  before_save :downcase_username

  # Virtual login attribute that allows users to log in using either username or email
  def login
    @login || self.username || self.email
  end

  
  # Allow login with either email or username
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
  end


  private

  def downcase_username
    self.username = username.downcase if username.present?
  end

end