class CreateUserDeviceTokensUsersJoin < ActiveRecord::Migration
  def change
    create_table :user_device_tokens_users, :id => false do |t|
      t.integer "user_device_token_id", :null => false
      t.integer "user_id", :null => false
    end
    add_index("user_device_tokens_users", ["user_device_token_id", "user_id"], :name => "user_device_tokens_users_index")
  end
end
