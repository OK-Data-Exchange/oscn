class AddRolesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :admin_role, :boolean, default: false
    add_column :users, :user_role, :boolean, default: true
  end
end
