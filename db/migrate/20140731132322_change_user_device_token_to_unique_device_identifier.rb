class ChangeUserDeviceTokenToUniqueDeviceIdentifier < ActiveRecord::Migration
  def up
    rename_table("user_device_tokens", "unique_device_identifiers")
    rename_column("unique_device_identifiers", "token", "udid")
    rename_table("user_device_tokens_users", "unique_device_identifiers_users")
    rename_column("unique_device_identifiers_users", "user_device_token_id", "unique_device_identifier_id")
  end

  def down
    rename_column("unique_device_identifiers_users", "unique_device_identifier_id", "user_device_token_id")
    rename_table("unique_device_identifiers_users", "user_device_tokens_users")
    rename_column("unique_device_identifiers", "udid", "token")
    rename_table("unique_device_identifiers", "user_device_tokens")
  end
end
