class AddPublicToAthleticEvents < ActiveRecord::Migration
  def change
    add_column :athletic_events, :public, :boolean, default: false
  end
end
