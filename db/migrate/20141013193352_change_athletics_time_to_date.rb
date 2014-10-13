# modifies the athletic events to match the sntax of simple events
class ChangeAthleticsTimeToDate < ActiveRecord::Migration
  def change
    rename_column :athletic_events, :start_time, :start_date
    rename_column :athletic_events, :end_time, :end_date
  end
end
