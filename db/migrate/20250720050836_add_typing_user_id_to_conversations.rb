class AddTypingUserIdToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :typing_user_id, :integer
  end
end
