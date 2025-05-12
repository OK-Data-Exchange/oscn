class DocketEvent < ApplicationRecord
  ERROR_STRINGS = ['CASE FILED IN ERROR']
  MAIN_EVENT_TYPES = %w[
    CTFREE

    BWI$
    BWIAA
    BWIAR

    DISMISSED
    DEFERRED
    CONVICTED
  ]

  belongs_to :court_case
  belongs_to :docket_event_type
  belongs_to :party, optional: true
  has_many :links, class_name: 'DocketEventLink', dependent: :destroy
  validates :event_on, presence: true

  scope :for_code, ->(code) { joins(:docket_event_type).where(docket_event_types: { code: code }) }
  scope :with_text, ->(string) { where('description LIKE :q', q: "%#{string}%") }
  scope :with_credit, -> { where.not(credit: 0) }
  scope :without_amount, -> { where(amount: 0) }
  scope :without_adjustment, -> { where(adjustment: 0) }
  scope :without_payment, -> { where(payment: 0) }
  scope :negative, -> { where('amount < 0') }
  scope :positive, -> { where('amount > 0') }

  scope :main, lambda {
    joins(:docket_event_type)
      .where(
        docket_event_type: {
          code: MAIN_EVENT_TYPES
        }
      )
  }

  def error?
    ERROR_STRINGS.any? { |string| description.downcase.include? string.downcase }
  end
end
