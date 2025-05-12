class TulsaBlotter::Offense < ApplicationRecord
  include ::Offense

  belongs_to :arrest, class_name: 'TulsaBlotter::Arrest', foreign_key: :arrests_id

  def case_link
    return null unless clean_case_number.present?

    ::CourtCase.link(clean_case_number, nil)
  end

  def offense_description
    description
  end
end
