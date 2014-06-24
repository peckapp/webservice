class CreateUserDeviceTokens < ActiveRecord::Migration
  def change
    create_table :user_device_tokens do |t|
      t.integer "user_id", :null => false #links to users table
      t.string "token" #unique text value associated to each device peck is installed on.
      t.timestamps
    end
    add_index("user_device_tokens", "user_id")
  end
end
