class RenameSimpleEventEventUrlToUrl < ActiveRecord::Migration
  def change
    rename_column :simple_events, :event_url, :url
  end
end
