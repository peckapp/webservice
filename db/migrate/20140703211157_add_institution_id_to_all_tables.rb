class AddInstitutionIdToAllTables < ActiveRecord::Migration
  def up
    add_column("activity_logs", "institution_id", :integer, :null => false)
    add_column("circle_members", "institution_id", :integer, :null => false)
    add_column("comments", "institution_id", :integer, :null => false)
    add_column("configurations", "institution_id", :integer, :null => false)
    add_column("dining_periods", "institution_id", :integer, :null => false)
    add_column("event_attendees", "institution_id", :integer, :null => false)
    add_column("event_views", "institution_id", :integer, :null => false)
    add_column("notification_views", "institution_id", :integer, :null => false)
    add_column("push_notifications", "institution_id", :integer, :null => false)
    add_column("subscriptions", "institution_id", :integer, :null => false)
    add_column("user_device_tokens", "institution_id", :integer, :null => false)
  end

  def down
    remove_column("user_device_tokens", "institution_id")
    remove_column("subscriptions", "institution_id")
    remove_column("push_notifications", "institution_id")
    remove_column("notification_views", "institution_id")
    remove_column("event_views", "institution_id")
    remove_column("event_attendees", "institution_id")
    remove_column("dining_periods", "institution_id")
    remove_column("configurations", "institution_id")
    remove_column("comments", "institution_id")
    remove_column("circle_members", "institution_id")
    remove_column("activity_logs", "institution_id")
  end
end
