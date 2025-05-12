class Roster::PersonDetailsPerson < ApplicationRecord
  self.table_name = 'roster_people_details'
  self.primary_key = :id

  belongs_to :person, foreign_key: :roster_people_merged_id
  belongs_to :person_detail, foreign_key: :roster_people_details_merged_id
end
