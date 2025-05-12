require 'date'

class Party < ApplicationRecord
  belongs_to :party_type
  belongs_to :parent_party, optional: true
  has_many :case_parties, dependent: :destroy
  has_many :court_cases, through: :case_parties
  has_many :counsel_parties, dependent: :destroy
  has_many :counsels, through: :counsel_parties
  has_many :docket_events, dependent: :destroy
  has_many :addresses, class_name: 'PartyAddress', dependent: :destroy
  has_many :aliases, class_name: 'PartyAlias', dependent: :destroy
  has_many :issue_parties, dependent: :destroy
  has_one :party_html, dependent: :destroy
  validates :birth_month, inclusion: 1..12, allow_nil: true
  validates :birth_year, inclusion: 1800..DateTime.current.year, allow_nil: true

  scope :older_than, ->(date) { joins(:party_html).where('party_htmls.scraped_at < ?', date) }
  scope :without_html, -> { left_outer_joins(:party_html).where(party_htmls: { html: nil }) }
  scope :without_birthday, -> { where(birth_month: nil) } # TODO: Validate presence of party_type?
  scope :without_parent, -> { where(parent_party_id: nil) }
  scope :with_parent, -> { where.not(parent_party_id: nil) }
  scope :arresting_agency, -> { joins(:party_type).where(party_types: { name: 'arresting_agency' }) }
  scope :defendant, -> { joins(:party_type).where(party_types: { name: 'defendant' }) }

  def birth_date_string
    "#{Date::ABBR_MONTHNAMES[birth_month]}, #{birth_year}" if birth_month and birth_year
  end

  def most_recent_address
    addresses.sort_by(&:record_on).reverse.first
  end
end
