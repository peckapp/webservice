class CreateDiningPeriods < ActiveRecord::Migration
  def change
    create_table :dining_periods do |t|
      t.time "start_time", :null => false
      t.time "end_time", :null => false
      t.integer "day_of_week" # 0 = sunday, 1 = monday,..., 6 = saturday

      t.timestamps
    end
  end
end
