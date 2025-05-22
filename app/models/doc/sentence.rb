class Doc::Sentence < ApplicationRecord
  include ::Offense

  belongs_to :profile, class_name: 'Doc::Profile', foreign_key: 'doc_profile_id'
  belongs_to :offense_code, class_name: 'Doc::OffenseCode', optional: true, foreign_key: 'doc_offense_code_id'
  belongs_to :court_case, optional: true

  def offense_description
    "#{js_date}:
     Sentenced to #{incarcerated_term_in_years} years,
     #{probation_term_in_years} years probation,
     #{is_life_sentence ? "is" : "not"} life sentence,
     #{is_death_sentence ? "is" : "not"} death sentence
    "
  end

  def case_link
    return null unless clean_case_number.present?

    county = DocSentencingCounty.find_by(name: sentencing_county)&.county

    ::CourtCase.link(clean_case_number, nil, county&.name || 'tulsa')
  end
end
