class ProfessionTag < ApplicationRecord
  belongs_to :tag
  has_many :user_profession_tags
  has_many :users, through: :user_profession_tags
end
