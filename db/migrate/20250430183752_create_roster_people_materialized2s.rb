class CreateRosterPeopleMaterialized2s < ActiveRecord::Migration[7.0]
  def change
    create_view :roster_people_materialized2, materialized: true
  end
end
