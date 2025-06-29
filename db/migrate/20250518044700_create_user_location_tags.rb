class CreateUserLocationTags < ActiveRecord::Migration[7.1]
  def change
    create_table :user_location_tags do |t|
      t.references :user, null: false, foreign_key: true
      t.references :location_tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
