class MakeRichJoinBetweenUsersUdiDs < ActiveRecord::Migration
  def up
    add_column :unique_device_identifiers_users, :id, :primary_key
    rename_table :unique_device_identifiers_users, :udid_users
  end

  def down
    rename_table :udid_users, :unique_device_identifiers_users
    remove_column :unique_device_identifiers_users, :id
  end
end
