class CreateDiningPeriods < ActiveRecord::Migration
  def change
    create_table :dining_periods do |t|
      t.integer "dining_place_id", :null => false # links to dining places table
      t.integer "dining_opportunity_id", :null => false # links to dining opportunities table
      t.time "start_time", :null => false
      t.time "end_time", :null => false
      t.integer "day_of_week" # 0 = sunday, 1 = monday,..., 6 = saturday

      t.timestamps
    end
    add_index("dining_periods", "dining_place_id")
    add_index("dining_periods", "dining_opportunity_id")
  end
end
