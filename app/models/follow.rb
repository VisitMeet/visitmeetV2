class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", inverse_of: :active_relationships
  belongs_to :followed, class_name: "User", inverse_of: :passive_relationships

  validates :follower_id, uniqueness: { scope: :followed_id }
end
