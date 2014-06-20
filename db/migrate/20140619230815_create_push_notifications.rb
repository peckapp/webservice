class CreatePushNotifications < ActiveRecord::Migration
  def change
    create_table :push_notifications do |t|
      t.integer "user_id", :null => false
      t.string "type", :null => false # i.e. invite, update, share, or comment
      t.string "response" # user's response to push notification

      t.timestamps
    end
    add_index("push_notifications", "user_id")
    add_index("push_notifications", "type")
  end
end
