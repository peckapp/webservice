class AlterPushNotificationsType < ActiveRecord::Migration
  def change
    rename_column("push_notifications", "type", "notification_type")
  end
end
