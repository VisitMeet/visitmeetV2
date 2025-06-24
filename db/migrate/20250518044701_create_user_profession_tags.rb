class CreateUserProfessionTags < ActiveRecord::Migration[7.1]
  def change
    create_table :user_profession_tags do |t|
      t.references :user, null: false, foreign_key: true
      t.references :profession_tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
