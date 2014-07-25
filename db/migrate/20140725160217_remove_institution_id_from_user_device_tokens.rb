class RemoveInstitutionIdFromUserDeviceTokens < ActiveRecord::Migration
  def up
    remove_column("user_device_tokens", "institution_id")
  end

  def down
    add_column("user_device_tokens", "institution_id", :integer, :null => false)
  end
end
