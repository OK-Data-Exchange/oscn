class TulsaBlotter::Arrest < ApplicationRecord
  include ::Booking

  has_many :offenses, class_name: 'TulsaBlotter::Offense', foreign_key: 'arrests_id'
  has_and_belongs_to_many :page_htmls, class_name: 'TulsaBlotter::PageHtml'
  has_one :arrest_details_html, class_name: 'TulsaBlotter::ArrestDetailsHtml', foreign_key: 'arrest_id'

  validates :booking_id, presence: true

  def all_arrests
    ::TulsaBlotter::Arrest.where(dlm: dlm)
  end

  def booking_more_info
    "From Tulsa County Jail website for #{dlm}"
  end

  def booking_facility
    "David L. Moss"
  end

  def booking_arrested_at
    arrest_date || booking_date
  end

  def booking_released_at
    release_date || last_scraped_at&.to_datetime
  end

  def booking_offenses
    offenses
  end

  def booking_id
    attributes['booking_id']
  end
end
