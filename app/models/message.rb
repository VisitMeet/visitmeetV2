class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :body, presence: true

  scope :unread, -> { where(read_at: nil) }

  def mark_as_read
    update(read_at: Time.current)
  end
end
