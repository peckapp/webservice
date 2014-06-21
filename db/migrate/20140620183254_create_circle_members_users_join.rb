class CreateCircleMembersUsersJoin < ActiveRecord::Migration
  def change
    create_table :circle_members_users, :id => false do |t|
      t.integer "user_id", :null => false # inviter of circle member
      t.integer "circle_member_id", :null => false
    end
    add_index("circle_members_users", "user_id")
    add_index("circle_members_users", "circle_member_id")
  end
end
