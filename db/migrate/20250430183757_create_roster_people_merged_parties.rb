class CreateRosterPeopleMergedParties < ActiveRecord::Migration[7.0]
  def change
    create_view :roster_people_merged_parties, materialized: true
    add_index "roster_people_merged_parties", ["party_id"], name: "party_id_roster_people_merged_parties"
    add_index "roster_people_merged_parties", ["roster_people_merged_id"], name: "ids_roster_people_merged_parties"
  end
end
