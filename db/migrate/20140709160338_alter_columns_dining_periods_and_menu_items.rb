class AlterColumnsDiningPeriodsAndMenuItems < ActiveRecord::Migration
  def up
    change_column("dining_periods", "dining_opportunity_id", :integer, :null => true)
    change_column("dining_periods", "dining_place_id", :integer, :null => true)
    change_column("menu_items", "dining_opportunity_id", :integer, :null => true)
    change_column("menu_items", "dining_place_id", :integer, :null => true)
  end

  def down
    change_column("menu_items", "dining_place_id", :integer, :null => false)
    change_column("menu_items", "dining_opportunity_id", :integer, :null => false)
    change_column("dining_periods", "dining_place_id", :integer, :null => false)
    change_column("dining_periods", "dining_opportunity_id", :integer, :null => false)
  end
end
