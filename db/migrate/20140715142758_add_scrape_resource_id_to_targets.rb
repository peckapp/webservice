class AddScrapeResourceIdToTargets < ActiveRecord::Migration

  def change
    add_column "menu_items", "scrape_resource_id",:integer
    add_column "simple_events", "scrape_resource_id", :integer
    add_column "athletic_events", "scrape_resource_id", :integer
  end
end
