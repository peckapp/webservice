class AlterEvents < ActiveRecord::Migration
  def change
    # change table name to differenciate between normal and athletic events
    rename_table("events", "simple_events")
    rename_column("event_members", "event_id", "simple_event_id")
  end
end
