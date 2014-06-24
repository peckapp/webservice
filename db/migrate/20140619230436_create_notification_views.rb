class CreateNotificationViews < ActiveRecord::Migration
  def change
    create_table :notification_views do |t|
      t.integer "user_id", :null => false
      t.integer "activity_log_id", :null => false
      t.datetime "date_viewed"
      t.boolean "viewed", :null => false

      t.timestamps
    end
    add_index("notification_views", "user_id")
    add_index("notification_views", "activity_log_id")
  end
end
