class Pd::Offense < ApplicationRecord
  include ::Offense

  belongs_to :booking, class_name: 'Pd::Booking'
  has_many :offense_minutes, class_name: 'Pd::OffenseMinute', dependent: :destroy
  validates :offense_seq, presence: true

  def case_link
    return null unless clean_case_number.present?

    ::CourtCase.link(clean_case_number, nil)
  end

  def offense_description
    attributes['offense_description']
  end
end
