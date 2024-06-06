class Issue < ApplicationRecord
  belongs_to :court_case
  belongs_to :count_code, optional: true
  has_many :issue_parties, dependent: :destroy
end
