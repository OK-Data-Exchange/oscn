class CreateRosterPeopleDetails < ActiveRecord::Migration[7.0]
  def change
    create_view :roster_people_details, materialized: true
  end
end
