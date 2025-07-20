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

  # Offerings association
  has_many :offerings, dependent: :destroy
  
  # Booking associations
  has_many :bookings, dependent: :destroy  # Bookings I've made as traveler
  has_many :host_bookings, through: :offerings, source: :bookings  # Bookings for my offerings

  has_one_attached :profile_picture

  # Follower/Following Associations
  has_many :active_relationships, class_name: "Follow",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Follow",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # Conversations and Messages
  has_many :conversations, foreign_key: :sender_id, dependent: :destroy
  has_many :messages, dependent: :destroy

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end


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
