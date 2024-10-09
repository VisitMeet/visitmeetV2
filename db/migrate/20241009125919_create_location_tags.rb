class CreateLocationTags < ActiveRecord::Migration[7.1]
  def change
    create_table :location_tags do |t|
      t.string :location

      t.timestamps
    end
  end
end
