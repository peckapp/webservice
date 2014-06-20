class CreateEventComments < ActiveRecord::Migration
  def change
    create_table :event_comments do |t|
      t.string "category", :null => false # simple or athletic event?
      t.integer "comment_from", :null => false # ID of simple or athletic event
      t.integer "user_id", :null => false # links to users table. Comment was posted by this user.
      t.text "comment", :null => false

      t.timestamps
    end
    add_index("event_comments", "comment_from")
    add_index("event_comments", "user_id")
  end
end
