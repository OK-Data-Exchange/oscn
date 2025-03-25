class CreateOkCountyJailPdf < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_county_jail_bookings do |t|
      t.string :booking_number
      t.string :full_name
      t.date :dob
      t.datetime :booked_at
      t.integer :height_in
      t.integer :weight
      t.string :eyes
      t.string :hair_color
      t.string :hair_length
      t.string :skin

      t.timestamps
    end


    create_table :ok_county_jail_offenses do |t|
      t.references :ok_county_jail_bookings, null: false, foreign_key: true
      t.string :code
      t.string :description
      t.string :case_number
      t.string :bond

      t.timestamps
    end
  end
end
