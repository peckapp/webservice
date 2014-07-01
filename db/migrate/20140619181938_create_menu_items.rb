class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.string "name", :null => false
      t.integer "institution_id", :null => false # link to institutions table
      t.string "details_link"
      t.string "small_price"
      t.string "large_price"
      t.string "combo_price"

      t.timestamps
    end
    add_index("menu_items", "institution_id")
  end
end
