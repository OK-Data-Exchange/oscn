class CreateRosterPeopleMergeds < ActiveRecord::Migration[7.0]
  def change
    create_view :roster_people_merged, materialized: true
    add_index "roster_people_merged", ["dlms"], name: "dlms_roster_people_merged"
    add_index "roster_people_merged", ["doc_numbers"], name: "doc_numbers_people_merged"
    add_index "roster_people_merged", ["party_ids"], name: "party_ids_roster_people_merged"
  end
end
