class AddAuthenticationTokenToUsers < ActiveRecord::Migration
  def change
    add_column("users", "authentication_token", :string, {:null => false})
  end
end
