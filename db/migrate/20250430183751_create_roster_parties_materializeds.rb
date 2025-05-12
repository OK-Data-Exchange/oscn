class CreateRosterPartiesMaterializeds < ActiveRecord::Migration[7.0]
  def change
    create_view :roster_parties_materialized, materialized: true
  end
end
