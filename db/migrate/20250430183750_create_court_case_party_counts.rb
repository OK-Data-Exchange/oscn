class CreateCourtCasePartyCounts < ActiveRecord::Migration[7.0]
  def change
    create_view :court_case_party_counts, materialized: true
    add_index "court_case_party_counts", ["court_case_id"], name: "court_case_party_counts_court_case_id"
  end
end
