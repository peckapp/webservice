class CreateEventViews < ActiveRecord::Migration
  def change
    create_table :event_views do |t|
      t.integer "user_id", :null => false # links to users table
      t.string "category", :null => false # simple or athletic event?
      t.integer "event_viewed", :null => false # ID of simple or athletic event
      t.datetime "date_viewed"
      t.timestamps
    end
    add_index("event_views", "user_id")
    add_index("event_views", "event_viewed")
  end
end
