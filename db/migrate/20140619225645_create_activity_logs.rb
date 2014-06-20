class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.integer "sender", :null => false, :references => "users" # links to users table
      t.integer "receiver", :null => false, :references => "users"
      t.integer "event_author", :null => false, :references => "users"
      t.string "category", :null => false # simple or athletic event?
      t.integer "from_event"
      t.integer "circle_id" # links to circles table
      t.string "type_of_activity", :null => false # i.e. invite, update, share, comment
      t.string "message", :null => false # message shown to user informing of activity
      t.boolean "read_status", :null => false

      t.timestamps
    end
    add_index("activity_logs", "sender")
    add_index("activity_logs", "receiver")
    add_index("activity_logs", "event_author")
    add_index("activity_logs", "from_event")
    add_index("activity_logs", "circle_id")
    add_index("activity_logs", "type_of_activity")
  end
end
