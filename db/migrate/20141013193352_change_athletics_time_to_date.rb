# modifies the athletic events to match the sntax of simple events
class ChangeAthleticsTimeToDate < ActiveRecord::Migration
  def change
    rename_column :athletic_events, :start_date, :start_date
    rename_column :athletic_events, :end_date, :end_date
  end
end
