class LocationTag < ApplicationRecord
  validates :location, presence: true, uniqueness: true

  before_validation :downcase_location

  private

  def downcase_location
    self.location = location.downcase if location.present?
  end
end
