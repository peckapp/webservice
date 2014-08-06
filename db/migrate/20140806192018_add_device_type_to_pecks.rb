class AddDeviceTypeToPecks < ActiveRecord::Migration
  def up
    add_column :pecks, :device_type, :string
  end

  def down
    remove_column :pecks, :device_type
  end
end
