class CreateDiningPlacesMenuItemsJoin < ActiveRecord::Migration
  def change
    create_table :dining_places_menu_items, :id => false do |t|
      t.integer "dining_place_id", :null => false
      t.integer "menu_item_id", :null => false
    end
    add_index("dining_places_menu_items", ["dining_place_id", "menu_item_id"], :name => "dining_places_menu_items_index")
  end
end
