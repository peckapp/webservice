class AllowNullsInUsers < ActiveRecord::Migration
  def up
    change_column :users, :first_name, :string, :null => true
    change_column :users, :last_name, :string, :null => true
    change_column :users, :username, :string, :null => true
    change_column :users, :api_key, :string, :null => true
    change_column :users, :authentication_token, :string, :null => true
  end

  def down
    change_column :users, :first_name, :string, :null => false
    change_column :users, :last_name, :string, :null => false
    change_column :users, :username, :string, :null => false
    change_column :users, :api_key, :string, :null => false
    change_column :users, :authentication_token, :string, :null => false
  end
end
