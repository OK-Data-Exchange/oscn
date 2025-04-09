class OkCountyJail::Booking < ApplicationRecord
  has_many :offenses, class_name: 'OkCountyJail::Offense', dependent: :destroy
end
