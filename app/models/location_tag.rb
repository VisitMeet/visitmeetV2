class LocationTag < ApplicationRecord
  belongs_to :tag
  has_many :user_location_tags
  has_many :users, through: :user_location_tags
end
