class CreatePdOffenseMinutes < ActiveRecord::Migration[6.0]
  def change
    create_table :pd_offense_minutes do |t|
      t.references :offense, null: false, foreign_key: {to_table: :pd_offenses}
      t.datetime :minute_date
      t.string :minute
      t.string :minute_by
      t.string :judge
      t.string :next_proceeding
    end
  end
end
