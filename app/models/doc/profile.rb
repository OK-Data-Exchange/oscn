class Doc::Profile < ApplicationRecord
  belongs_to :roster, optional: true
  has_many :sentences, class_name: 'Doc::Sentence', foreign_key: 'doc_profile_id', dependent: :destroy
  has_many :aliases, class_name: 'Doc::Alias', foreign_key: 'doc_profile_id', dependent: :destroy
  has_many :statuses, class_name: 'Doc::Status', foreign_key: 'doc_profile_id', dependent: :destroy

  # TODO: move this (and all other doc validation) to the database level since we're doing upsert_all
  validates :last_name, :birth_date, :doc_number, :status, :sex, presence: true

  enum status: [:active, :inactive]
  enum sex: [:male, :female]

  def height_string
    "#{height_ft}' #{height_in}\""
  end

  def current_facility
    latest_status.facility
  end

  def latest_status
    statuses.sort_by(&:date).reverse.first
  end

  def facility_timeline
    timeline = []
    statuses.sort_by(&:date).each do |status|
      if timeline[-1] && timeline[-1][:facility] == status.facility
        timeline[-1][:last_seen] = status.date
      else
        timeline << {
          first_seen: status.date,
          facility: status.facility,
          last_seen: status.date
        }
      end
    end
    timeline
  end
end
