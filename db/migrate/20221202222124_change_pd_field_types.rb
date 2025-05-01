class ChangePdFieldTypes < ActiveRecord::Migration[6.0]
  def change
    change_column :pd_bookings, :current_age, 'integer USING CAST(current_age AS integer)'
    change_column :pd_bookings, :height, 'integer USING CAST(height AS integer)'
    change_column :pd_bookings, :weight, 'float USING CAST(weight AS float)'
    change_column :pd_bookings, :age_at_booking, 'integer USING CAST(age_at_booking AS integer)'
    change_column :pd_bookings, :age_at_release, 'integer USING CAST(age_at_release AS integer)'

    change_column :pd_offenses, :offense_seq, 'integer USING CAST(offense_seq AS integer)'
    change_column :pd_offenses, :bond_amount, 'float USING CAST(bond_amount AS float)'
    change_column :pd_offenses, :jail_term, 'integer USING CAST(jail_term AS integer)'



  end
end
