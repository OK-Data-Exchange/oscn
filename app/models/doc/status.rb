class Doc::Status < ApplicationRecord
  include ::Booking
  belongs_to :profile, class_name: 'Doc::Profile', foreign_key: 'doc_profile_id'
  attr_accessor :inferred_released_at

  def booking_more_info
    "DATES ARE BY QUARTER. This means booking may have happened any time during the entire quarter. DOC Booking for #{profile.doc_number}."
  end

  def booking_facility
    facility
  end

  def booking_arrested_at
    date - 3.months
  end

  def booking_released_at
    inferred_released_at ? inferred_released_at : date
  end

  def booking_offenses
    [
      profile
        .sentences
        .filter { |x| x.js_date <= date }
        .sort_by(&:js_date)
        .reverse
        .first
    ]
  end

  def booking_id
    id
  end
end
