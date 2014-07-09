class AlterPushNotificationsType < ActiveRecord::Migration
  def change
    # rename_column("push_notifications", "type", "notification_type")
    rename_column("dining_opportunities", "type", "dining_opportunity_type")
    rename_column("events_page_urls", "type", "events_page_url_type")
  end
end
