class CreateUserTags < ActiveRecord::Migration[7.1]
  def up
    create_table :user_tags, if_not_exists: true do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :user_tags, if_exists: true
  end
end
