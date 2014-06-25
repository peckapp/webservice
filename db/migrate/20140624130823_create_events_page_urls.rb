class CreateEventsPageUrls < ActiveRecord::Migration
  def change
    create_table :events_page_urls do |t|
      t.integer "institution_id", :null => false
      t.string "url", :null => false
      t.string "type"

      t.timestamps
    end
    add_index("events_page_urls", "institution_id")
    add_index("events_page_urls", "type")
  end
end
