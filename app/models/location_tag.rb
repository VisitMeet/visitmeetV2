class LocationTag < ApplicationRecord
  validates :location, presence: true, uniqueness: true, format: { with: /\A[a-z\s]+\z/, message: "only allows lowercase letters and spaces" }

  before_validation :downcase_location

  private

  def downcase_location
    self.location = location.downcase if location.present?
  end
end
