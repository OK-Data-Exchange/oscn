class CreateRosterPeopleMergedDocNumbers < ActiveRecord::Migration[7.0]
  def change
    create_view :roster_people_merged_doc_numbers, materialized: true
    add_index "roster_people_merged_doc_numbers", ["doc_number"], name: "doc_numbers_roster_people_merged_doc_number"
    add_index "roster_people_merged_doc_numbers", ["roster_people_merged_id"], name: "ids_numbers_roster_people_merged_doc_number"
  end
end
