class RemoveDeviceTypeColumnFromPecksAndAddToUniqueDeviceIdentifiers < ActiveRecord::Migration
  def up
    add_column :unique_device_identifiers, :device_type, :string
    remove_column :pecks, :device_type
  end

  def down
    add_column :pecks, :device_type, :string
    remove_column :unique_device_identifiers, :device_type
  end
end
