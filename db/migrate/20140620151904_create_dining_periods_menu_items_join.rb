class CreateDiningPeriodsMenuItemsJoin < ActiveRecord::Migration
  def change
    create_table :dining_periods_menu_items, :id => false do |t|
      t.integer "dining_period_id", :null => false
      t.integer "menu_item_id", :null => false
    end
    add_index("dining_periods_menu_items", ["dining_period_id", "menu_item_id"], :name => "dining_periods_menu_items_index")
  end
end
