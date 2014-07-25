class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string "title", :limit => 100, :null => false
      t.text "announcement_description"
      t.integer "institution_id", :null => false # links to institution table
      t.integer "user_id" # links to user table # => creator
      t.integer "department_id" # links to dept table # => creator
      t.integer "club_id" # links to club table # => creator
      t.integer "circle_id" # links to circle table # => creator
      t.boolean "public", :default => false # => determines if announcement is public or private
      t.integer "comment_count" # use count based on comments table
      t.boolean "deleted", :default => false # keeps track of whether announcement has been deleted
      t.timestamps
    end
    add_index("announcements", "title")
    add_index("announcements", "institution_id")
    add_index("announcements", "user_id")
    add_index("announcements", "department_id")
    add_index("announcements", "club_id")
    add_index("announcements", "circle_id")
  end
end
