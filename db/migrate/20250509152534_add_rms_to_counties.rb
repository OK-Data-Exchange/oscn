class AddRmsToCounties < ActiveRecord::Migration[7.0]
  def change
    add_column :counties, :rms, :string, default: 'OCIS'
  end
end
