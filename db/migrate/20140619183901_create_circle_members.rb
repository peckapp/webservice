class CreateCircleMembers < ActiveRecord::Migration
  def change
    create_table :circle_members do |t|
      t.integer "circle_id", :null => false # links to circles table
      t.integer "user_id", :null => false # links to users table. Member
      t.integer "invited_by", :null => false, :references => "users" # links to users table. member was invited by this user
      t.datetime "date_added"

      t.timestamps
    end
    add_index("circle_members", "circle_id")
    add_index("circle_members", "user_id")
    add_index("circle_members", "invited_by")
  end
end
