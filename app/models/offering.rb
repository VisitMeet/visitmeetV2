class Offering < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 20, maximum: 1000 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :location, presence: true, length: { minimum: 2, maximum: 100 }
  
  before_validation :normalize_location
  
  # Scopes
  scope :available, -> { where(id: where.not(id: Booking.accepted.upcoming.select(:offering_id))) }
  
  def host
    user
  end
  
  def has_upcoming_bookings?
    bookings.accepted.upcoming.exists?
  end
  
  private
  
  def normalize_location
    self.location = location.strip.downcase if location.present?
  end
end
