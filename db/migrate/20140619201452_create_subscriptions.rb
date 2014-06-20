class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer "user_id", :null => false# links to users table
      t.string "category", :null => false # what kind of subscription?
      t.integer "subscribed_to", :null => false # ID of club, team, or dept.

      t.timestamps
    end
    add_index("subscriptions", "user_id")
    add_index("subscriptions", "subscribed_to")
  end
end
