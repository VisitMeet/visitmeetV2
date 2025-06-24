class UserLocationTag < ApplicationRecord
  belongs_to :user
  belongs_to :location_tag
end
