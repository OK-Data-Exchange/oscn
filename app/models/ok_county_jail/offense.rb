class OkCountyJail::Offense < ApplicationRecord
  belongs_to :booking, class_name: 'OkCountyJail::Booking'
end
