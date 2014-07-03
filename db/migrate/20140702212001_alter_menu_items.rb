class AlterMenuItems < ActiveRecord::Migration
  def change
    add_column("menu_items", "dining_opportunity_id", :integer, :null => false)
    add_column("menu_items", "dining_place_id", :integer, :null => false)
    add_column("menu_items", "date_available", :date, :null => false)
  end
end
