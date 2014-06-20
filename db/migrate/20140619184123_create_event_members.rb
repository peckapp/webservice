class CreateEventMembers < ActiveRecord::Migration
  def change
    create_table :event_members do |t|
      t.integer "event_id", :null => false #links to events table.
      t.integer "user_id", :null => false #links to users table. Member
      t.integer "invited_by", :null => false, :references => "users"#links to users table. Invited by this user.
      t.datetime "date_added"

      t.timestamps
    end
    add_index("event_members", "event_id")
    add_index("event_members", "user_id")
    add_index("event_members", "invited_by")
  end
end
