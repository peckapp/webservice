class AddInfoToScrapeResources < ActiveRecord::Migration
  def change
    add_column :scrape_resources, :info, :string
  end
end
