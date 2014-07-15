class UpdateScrapeResources < ActiveRecord::Migration
  def up
    drop_column "scrape_resources", "resource_type"
    add_column "scrape_resources", "resource_type_id", :integer
    add_column "scrape_resources", "pagination_selector_id", :integer
  end

  def down
    add_column "scrape_resources", "resource_type", :string
    drop_column "scrape_resources", "resource_type_id"
    drop_column "scrape_resources", "pagination_selector_id"
  end
end
