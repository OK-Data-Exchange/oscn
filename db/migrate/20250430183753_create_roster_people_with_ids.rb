class CreateRosterPeopleWithIds < ActiveRecord::Migration[7.0]
  def change
    create_view :roster_people_with_id, materialized: true
    add_index "roster_people_with_id", ["dlm"], name: "dlm_roster_people_with_id"
    add_index "roster_people_with_id", ["doc_number"], name: "doc_number_roster_people_with_id"
    add_index "roster_people_with_id", ["id"], name: "id_roster_people_with_id", unique: true
    add_index "roster_people_with_id", ["party_id"], name: "party_id_roster_people_with_id"
  end
end
