
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  attr_writer :login

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /\A[a-zA-Z0-9_.]+\z/, message: "can only contain letters, numbers, underscores, and dots"
  validate :validate_username

  before_save :downcase_username

  has_many :user_tags
  has_many :tags, through: :user_tags

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  private

  def downcase_username
    self.username = username.downcase if username.present?
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end
end
