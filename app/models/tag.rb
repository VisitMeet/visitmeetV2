class Tag < ApplicationRecord
  has_many :location_tags
  has_many :profession_tags

end
