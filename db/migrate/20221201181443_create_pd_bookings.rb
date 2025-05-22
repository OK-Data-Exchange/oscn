class CreatePdBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :pd_bookings do |t|
      t.string :jailnet_inmate_id
      t.string :initial_docket_id
      t.string :inmate_name
      t.string :inmate_aka
      t.datetime :birth_date
      t.string :city_of_birth
      t.string :state_of_birth
      t.string :current_age
      t.string :race
      t.string :gender
      t.string :height
      t.string :weight
      t.string :hair_color
      t.string :eye_color
      t.string :build
      t.string :complexion
      t.string :facial_hair
      t.string :martial_status
      t.string :emergency_contact
      t.string :emergency_phone
      t.string :drivers_state
      t.string :drivers_license
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :home_phone
      t.string :fbi_nbr
      t.string :osbi_nbr
      t.string :tpd_nbr
      t.string :age_at_booking
      t.string :age_at_release
      t.string :arrest_date
      t.string :arrest_by
      t.string :agency
      t.string :booking_date
      t.string :booking_by
      t.string :otn_nbr
      t.string :estimated_release_date
      t.string :release_date
      t.string :release_by
      t.string :release_reason
      t.string :weekend_server
      t.string :custody_level
      t.string :assigned_cell_id
      t.string :current_location
      t.string :booking_notes
      t.string :booking_alerts
      t.string :booking_trustees
    end
  end
end
