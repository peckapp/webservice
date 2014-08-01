class ChangePushNotificationsToPecks < ActiveRecord::Migration
  def up
    rename_table "push_notifications", "pecks"
    add_column "pecks", "send_push_notification", :boolean, :default => false 
    rename_column "pecks", "response", "message"
    add_column "pecks", "invited_by", :integer
  end

  def down
    remove_column "pecks", "invited_by"
    rename_column "pecks", "message", "response"
    remove_column "pecks", "send_push_notification"
    rename_table "pecks", "push_notifications"
  end
end
