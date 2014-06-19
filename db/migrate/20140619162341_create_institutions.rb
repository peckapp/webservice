class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string "name", :null => false
      t.string "street_address", :null => false
      t.string "city", :null => false
      t.string "state", :null => false
      t.string "country", :null => false
      t.float "gps_longitude", :null => false
      t.float "gps_latitude", :null => false
      t.float "range", :null => false
      t.integer "configuration_id", :null => false # links to configuration table
      t.string "api_key", :null => false

      t.timestamps
    end
    add_index("institutions", "name")
    add_index("institutions", "configuration_id")
  end
end
