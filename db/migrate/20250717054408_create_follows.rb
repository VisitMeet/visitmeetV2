class CreateFollows < ActiveRecord::Migration[7.1]
  def change
    create_table :follows do |t|
      t.integer :follower_id, null: false
      t.integer :followed_id, null: false

      t.timestamps
    end unless table_exists?(:follows)

    add_foreign_key :follows, :users, column: :follower_id unless foreign_key_exists?(:follows, :users, column: :follower_id)
    add_foreign_key :follows, :users, column: :followed_id unless foreign_key_exists?(:follows, :users, column: :followed_id)
    add_index :follows, [:follower_id, :followed_id], unique: true unless index_exists?(:follows, [:follower_id, :followed_id])
  end
end
