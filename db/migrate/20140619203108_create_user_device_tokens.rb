class CreateUserDeviceTokens < ActiveRecord::Migration
  def change
    create_table :user_device_tokens do |t|
      t.string "token" #unique text value associated to each device peck is installed on.
      t.timestamps
    end
  end
end
