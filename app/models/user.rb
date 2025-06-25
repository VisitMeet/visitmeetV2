class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:login]

  attr_writer :login

  # Validations & callbacks for username and full_name
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :username,
                      with: /\A[a-zA-Z0-9_.]+\z/,
                      message: "can only contain letters, numbers, underscores, and dots"
  validates :full_name, presence: true, length: { minimum: 2, maximum: 50 }
  validate :validate_username
  before_save :downcase_username

  # ————— New Tag Associations —————
  has_many :user_location_tags,  dependent: :destroy
  has_many :location_tags,       through: :user_location_tags

  has_many :user_profession_tags, dependent: :destroy
  has_many :profession_tags,      through: :user_profession_tags

  # — If you’re no longer using the generic Tag model, remove these:
  # has_many :user_tags
  # has_many :tags, through: :user_tags
  
  # Offerings association
  has_many :offerings, dependent: :destroy
  
  # Booking associations
  has_many :bookings, dependent: :destroy  # Bookings I've made as traveler
  has_many :host_bookings, through: :offerings, source: :bookings  # Bookings for my offerings

  has_one_attached :profile_picture


  # Devise login override (username OR email)
  def login
    @login || username || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h)
        .where(["lower(username) = :value OR lower(email) = :value",
                { value: login.downcase }])
        .first
    else
      where(conditions.to_h).first
    end
  end

  # Display helpers
  def display_name
    full_name.present? ? full_name : username
  rescue NoMethodError
    username
  end

  def name_with_username
    full_name.present? ? "#{full_name} (@#{username})" : "@#{username}"
  rescue NoMethodError
    "@#{username}"
  end

  def initials
    full_name.present? ? full_name.split.map(&:first).join.upcase : username.first.upcase
  rescue NoMethodError
    username.first.upcase
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