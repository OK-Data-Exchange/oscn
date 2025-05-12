class CreateRosterPeopleMergedDlms < ActiveRecord::Migration[7.0]
  def change
    create_view :roster_people_merged_dlms, materialized: true
    add_index "roster_people_merged_dlms", ["dlm"], name: "dlm_roster_people_merged_dlms"
    add_index "roster_people_merged_dlms", ["roster_people_merged_id"], name: "ids_roster_people_merged_dlms"
  end
end
