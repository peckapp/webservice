class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer "institution_id", :null => false # links to institution table
      t.string "first_name", :null => false
      t.string "last_name", :null => false
      t.string "username", :null => false
      t.text "blurb"
      t.string "facebook_link"
      t.string "facebook_token" # should not be null if fb_link is not null
      t.string "password_digest" # column for encrypted password
      t.string "api_key", :null => false
      t.boolean "active", :default => false # gets set to false when account is deleted

      t.timestamps
    end
    add_index("users", "institution_id")
    add_index("users", "last_name")
    add_index("users", "username")
  end
end
