class AllowUdidNull < ActiveRecord::Migration
  def up
    change_column "unique_device_identifiers", "udid", :string
  end

  def down
    change_column "unique_device_identifiers", "udid", :string, :null => false
  end
end
