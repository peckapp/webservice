class ImproveAthleticsTimes < ActiveRecord::Migration
  def up
    rename_column :athletic_events, :date_and_time, :start_time
    add_column :athletic_events, :end_time, :datetime
  end
end
