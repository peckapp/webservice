class LoosenScrapeResourceConstraints < ActiveRecord::Migration
  def up
    change_column :scrape_resources, :url, :string, null: true
  end

  def down
    change_column :scrape_resources, :url, :string, null: false
  end
end
