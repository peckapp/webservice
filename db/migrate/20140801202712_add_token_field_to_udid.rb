class AddTokenFieldToUdid < ActiveRecord::Migration
  def up
    add_column "unique_device_identifiers", "token", :string
  end

  def down
    remove_column "unique_device_identifiers", "token"
  end
end
