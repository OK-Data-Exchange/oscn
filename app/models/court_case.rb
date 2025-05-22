# Represents a single case within the OSCN system
class CourtCase < ApplicationRecord
  belongs_to :county
  belongs_to :case_type
  belongs_to :current_judge, class_name: 'Judge', optional: true
  has_many :case_parties, dependent: :destroy
  has_many :parties, through: :case_parties
  has_many :counts, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :counsel_parties, dependent: :destroy
  has_many :counsels, -> { distinct }, through: :counsel_parties
  has_many :docket_events, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :issue_parties, through: :issues
  has_many :links, through: :docket_events
  has_one :report_eviction
  has_many :roster_cases, class_name: 'Roster::Case'
  has_one :case_html, dependent: :destroy
  has_one :case_stat

  # Link to DOC data
  has_many :doc_sentences, class_name: 'Doc::Sentence'

  validates :oscn_id, :case_number, presence: true
  validates :oscn_id, uniqueness: { scope: :county_id }

  scope :without_html, -> { left_outer_joins(:case_html).where(case_htmls: { html: nil }) }
  scope :with_html, -> { joins(:case_html).where.not(case_htmls: { html: nil }) }
  scope :without_docket_events, -> { left_outer_joins(:docket_events).where(docket_events: { id: nil }) }
  scope :with_docket_events, -> { left_outer_joins(:docket_events).where.not(docket_events: { id: nil }) }
  scope :valid, -> { where.not("case_number LIKE '%-0'") }
  scope :active, -> { where(closed_on: nil) }
  scope :closed, -> { where.not(closed_on: nil) }
  scope :last_scraped, ->(date) { joins(:case_html).where(case_htmls: { scraped_at: date..DateTime.current }) }
  scope :older_than, ->(date) { joins(:case_html).where('case_htmls.scraped_at < ?', date) }
  # TODO: Make scope more dynamic to search for different errors
  scope :with_error, -> { where.not('logs @> ?', { events: nil }.to_json) }
  scope :for_county_name, ->(name) { joins(:county).where(counties: { name: name }) }
  scope :not_in_queue, -> { where(enqueued: false) }
  scope :small_claims, -> { joins(:case_type).where(case_types: { abbreviation: 'SC' }) }
  scope :days_young, ->(days) { where('filed_on >= ?', days.days.ago) }

  delegate :html, to: :case_html

  def self.mapping(county_id)
    where(county_id: county_id)
      .pluck(:case_number, :id).map { |case_number, id| ["#{county_id}-#{case_number}", id] }.to_h
  end

  def error?
    associations = [parties, current_judge, counsels, counts, events, docket_events]
    associations.all?(&:blank?) || docket_events.any?(&:error?)
  end

  def defendants
    parties.defendant
  end

  # todo: see if we can merge link methods
  def oscn_link
    "https://www.oscn.net/dockets/GetCaseInformation.aspx?db=#{county.name}&number=#{case_number}"
  end

  def case_link
    self.class.link(case_number, oscn_id, county.name)
  end

  def self.link(case_number, oscn_id, county = 'tulsa')
    "https://www.oscn.net/dockets/GetCaseInformation.aspx?db=#{county}&number=#{case_number}&cmid=#{oscn_id}"
  end
end
