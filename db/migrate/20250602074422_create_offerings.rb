class CreateOfferings < ActiveRecord::Migration[7.1]
  def change
    create_table :offerings do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :location
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
