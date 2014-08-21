class AddUrlToAthleticEvents < ActiveRecord::Migration
  def change
    add_column :athletic_events, :url, :string
  end
end
