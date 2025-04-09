class OkCountyJail::Offense < ApplicationRecord
  belongs_to :booking, class_name: 'OkCountyJail::Booking', foreign_key: 'ok_county_jail_bookings_id'
end
