class CreateCircleMembersUsersJoin < ActiveRecord::Migration
  def change
    create_table :circle_members_users, :id => false do |t|
      t.integer "user_id", :null => false # inviter of circle member
      t.integer "circle_member_id", :null => false
    end
    add_index("circle_members_users", ["user_id", "circle_member_id"], :name => "circle_members_users_index")
  end
end
