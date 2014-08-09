class AddEngineTypeToScrapeResource < ActiveRecord::Migration
  def change
    add_column :scrape_resources, :engine_type, :string
  end
end
