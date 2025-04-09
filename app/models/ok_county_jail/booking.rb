class OkCountyJail::Booking < ApplicationRecord
  has_many :offenses, class_name: 'OkCountyJail::Offense', dependent: :destroy, foreign_key: 'ok_county_jail_bookings_id'
end
