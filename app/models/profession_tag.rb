class ProfessionTag < ApplicationRecord
  validates :profession, presence: true, uniqueness: true, format: { with: /\A[a-z\s]+\z/, message: "only allows lowercase letters and spaces" }

  before_validation :downcase_profession

  private

  def downcase_profession
    self.profession = profession.downcase if profession.present?
  end
end
