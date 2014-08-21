class RenameEventViewsAndColumnName < ActiveRecord::Migration
  def change
    rename_table :event_views, :views
    rename_column :views, :event_viewed, :content_id
  end
end
