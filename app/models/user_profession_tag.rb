class UserProfessionTag < ApplicationRecord
  belongs_to :user
  belongs_to :profession_tag
end
