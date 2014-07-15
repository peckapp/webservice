class AddScrapeResourceIdToTargets < ActiveRecord::Migration
  sri = "scrape_resource_id"
  def change
    add_column "menu_items",sri,:integer
    add_column "simple_events", sri, :integer
    add_column "athletic_events", sri, :integer
  end
end
