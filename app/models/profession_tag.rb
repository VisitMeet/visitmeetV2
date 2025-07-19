class ProfessionTag < ApplicationRecord
  validates :profession, presence: true, uniqueness: true

  before_validation :downcase_profession

  private

  def downcase_profession
    self.profession = profession.downcase if profession.present?
  end
end
