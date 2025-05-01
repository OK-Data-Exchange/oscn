class Pd::Booking < ApplicationRecord
  include ::Booking

  has_many :offenses, class_name: 'Pd::Offense', dependent: :destroy
  default_scope { order(booking_date: :desc) }

  def first_name
    inmate_name.split.first
  end

  def last_name
    inmate_name.split.last
  end

  def height_string
    "#{height.digits[2]}' #{height.digits[1]}#{height.digits[0]}\""
  end

  def current_facility
    release_date.empty?
  end

  # todo: this we should make inmate be it's own table so we can use prefect here
  def all_bookings
    ::Pd::Booking.where(jailnet_inmate_id: jailnet_inmate_id)
  end

  def booking_more_info
    "Booking from jailnet for dlm #{jailnet_inmate_id}"
  end

  def booking_facility
    'David L. Moss'
  end

  def booking_arrested_at
    arrest_date&.to_datetime || booking_date&.to_datetime
  end

  def booking_released_at
    release_date&.to_datetime
  end

  def booking_offenses
    offenses
  end

  def booking_id
    id
  end
end
