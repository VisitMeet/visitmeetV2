class CreateProfessionTags < ActiveRecord::Migration[7.1]
  def change
    create_table :profession_tags do |t|
      t.string :profession

      t.timestamps
    end
  end
end
