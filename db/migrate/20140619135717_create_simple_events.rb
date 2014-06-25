class CreateSimpleEvents < ActiveRecord::Migration
  def change
    create_table :simple_events do |t|
      t.string "title", :limit => 100, :null => false
      t.text "event_description"
      t.integer "institution_id", :null => false # links to institution table
      t.integer "user_id" # links to user table # => creator
      t.integer "department_id" # links to dept table # => creator
      t.integer "club_id" # links to club table # => creator
      t.integer "circle_id" # links to circle table # => creator
      t.string "event_url" 
      t.boolean "open", :default => false # => determines if event is public or private
      t.string "image_url"
      t.integer "comment_count" # use count based on comments table
      t.datetime "start_date", :null => false
      t.datetime "end_date", :null => false
      t.boolean "deleted", :default => false # keeps track of whether event has been deleted
      t.timestamps
    end
    add_index("simple_events", "title")
    add_index("simple_events", "institution_id")
    add_index("simple_events", "user_id")
    add_index("simple_events", "department_id")
    add_index("simple_events", "club_id")
    add_index("simple_events", "circle_id")
  end
end
