class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer "institution_id", :null => false # links to institution table
      t.string "name", :null => false
      t.float "gps_longitude"
      t.float "gps_latitude"
      t.float "range"

      t.timestamps
    end
    add_index("locations", "institution_id")
    add_index("locations", "name")
  end
end
