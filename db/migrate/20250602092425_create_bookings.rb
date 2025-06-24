class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :offering, null: false, foreign_key: true
      t.date :requested_date, null: false
      t.integer :guests, null: false, default: 1
      t.text :message
      t.integer :status, null: false, default: 0
      t.decimal :total_amount, precision: 10, scale: 2

      t.timestamps
    end
    
    add_index :bookings, [:user_id, :offering_id]
    add_index :bookings, :status
    add_index :bookings, :requested_date
  end
end
