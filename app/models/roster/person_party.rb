class Roster::PersonParty < ApplicationRecord
  self.table_name = :roster_people_merged_parties
  belongs_to :party
end
