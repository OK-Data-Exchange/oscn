class AllowNullCountCodes < ActiveRecord::Migration[7.0]
  def change
    change_column_null :issues, :count_code_id, true
  end
end
