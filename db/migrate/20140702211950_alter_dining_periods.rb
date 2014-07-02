class AlterDiningPeriods < ActiveRecord::Migration
  def change
    add_column("dining_periods", "dining_opportunity_id", :integer, :null => false)
    add_column("dining_periods", "dining_place_id", :integer, :null => false)
  end
end
