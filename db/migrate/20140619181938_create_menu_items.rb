class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.string "name", :null => false
      t.integer "institution_id", :null => false # link to institutions table
      t.integer "dining_place_id", :null => false # link to dining places table
      t.integer "dining_period_id" # could this ever be null??
      t.string "details_link"
      t.string "small_price"
      t.string "large_price"
      t.string "combo_price"

      t.timestamps
    end
    add_index("menu_items", "institution_id")
    add_index("menu_items", "dining_place_id")
    add_index("menu_items", "dining_period_id")
  end
end
