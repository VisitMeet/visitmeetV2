class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :offering
  
  # Booking statuses
  enum status: {
    pending: 0,      # Initial request from traveler
    accepted: 1,     # Host accepted the booking
    declined: 2,     # Host declined the booking
    cancelled: 3,    # Booking was cancelled (by either party)
    completed: 4     # Experience completed
  }
  
  # Validations
  validates :requested_date, presence: true
  validates :guests, presence: true, 
            numericality: { greater_than: 0, less_than_or_equal_to: 20 }
  validates :total_amount, presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validate :requested_date_cannot_be_in_past
  validate :cannot_book_own_offering
  
  # Scopes
  scope :for_host, ->(user) { joins(:offering).where(offerings: { user_id: user.id }) }
  scope :for_traveler, ->(user) { where(user: user) }
  scope :upcoming, -> { where('requested_date >= ?', Date.current) }
  scope :past, -> { where('requested_date < ?', Date.current) }
  
  # Instance methods
  def host
    offering.user
  end
  
  def traveler
    user
  end
  
  def can_be_accepted?
    pending? && requested_date >= Date.current
  end
  
  def can_be_cancelled?
    (pending? || accepted?) && requested_date >= Date.current
  end
  
  def calculate_total_amount
    self.total_amount = offering.price * guests
  end
  
  private
  
  def requested_date_cannot_be_in_past
    if requested_date.present? && requested_date < Date.current
      errors.add(:requested_date, "can't be in the past")
    end
  end
  
  def cannot_book_own_offering
    if user_id == offering&.user_id
      errors.add(:base, "You cannot book your own offering")
    end
  end
end
