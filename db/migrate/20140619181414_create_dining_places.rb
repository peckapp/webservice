class CreateDiningPlaces < ActiveRecord::Migration
  def change
    create_table :dining_places do |t|
      t.integer "institution_id", :null => false # link to institutions table
      t.string "name", :null => false
      t.string "details_link"
      t.float "gps_longitude"
      t.float "gps_latitude"
      t.float "range"

      t.timestamps
    end
    add_index("dining_places", "institution_id")
    add_index("dining_places", "name")
  end
end
