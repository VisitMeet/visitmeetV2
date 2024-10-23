class CreateProfessionTags < ActiveRecord::Migration[7.1]
  def change
    create_table :profession_tags do |t|
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
