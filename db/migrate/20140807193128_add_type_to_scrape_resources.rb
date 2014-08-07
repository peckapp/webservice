class AddTypeToScrapeResources < ActiveRecord::Migration
  def change
    add_column :scrape_resources, :kind, :string
  end
end
