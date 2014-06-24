class CreateEventAttendees < ActiveRecord::Migration
  def change
    create_table :event_attendees do |t|
      t.integer "user_id", :null => false # links to users table. Attendee.
      t.integer "added_by", :null => false, :references => "users" # links to users table. Attendee added by this user.
      t.string "category", :null => false # simple or athletic event?
      t.integer "event_attended", :null => false # ID of simple or athletic event
      t.timestamps
    end
    add_index("event_attendees", "user_id")
    add_index("event_attendees", "added_by")
    add_index("event_attendees", "event_attended")
  end
end
