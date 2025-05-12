class CreateRosterPeopleDetailsMergeds < ActiveRecord::Migration[7.0]
  def change
    create_view :roster_people_details_merged, materialized: true
  end
end
