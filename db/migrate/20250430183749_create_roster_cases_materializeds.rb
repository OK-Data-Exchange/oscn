class CreateRosterCasesMaterializeds < ActiveRecord::Migration[7.0]
  def change
    create_view :roster_cases_materialized, materialized: true
  end
end
