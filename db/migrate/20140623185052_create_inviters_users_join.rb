class CreateInvitersUsersJoin < ActiveRecord::Migration
  def change
    create_table :inviters_users, :id => false do |t|
      t.integer "event_attendee_id", :null => false
      t.integer "user_id", :null => false
    end
    add_index("inviters_users", ["event_attendee_id","user_id"])
  end
end
