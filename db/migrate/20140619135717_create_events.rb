class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string "title", :limit => 100, :null => false
      t.text "event_description"
      t.integer "institution_id", :null => false # links to institution table
      # creator could also be a dept/club, how do we work that in?
      t.integer "user_id" # links to user table
      t.integer "department_id" # links to dept table
      t.integer "club_id" # links to club table
      # determines if event is public or private
      t.boolean "open", :default => false
      t.string "image_url"
      t.integer "circle_id" # links to circle table
      t.integer "comment_count" # use count based on comments table
      t.datetime "start_date", :null => false
      t.datetime "end_date", :null => false
      t.boolean "deleted", :default => false # keeps track of whether event has been deleted
      t.timestamps
    end
    add_index("events", "title")
    add_index("events", "institution_id")
    add_index("events", "user_id")
    add_index("events", "department_id")
    add_index("events", "club_id")
    add_index("events", "circle_id")
  end
end
