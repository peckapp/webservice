class AddDefaultsForScrapeModelBooleans < ActiveRecord::Migration
  def up
    change_column :data_resources, :foreign_key, :boolean, default: false
    change_column :crawl_seeds, :active, :boolean, default: false
  end

  def down
    change_column :data_resources, :foreign_key, :boolean
    change_column :crawl_seeds, :active, :boolean
  end
end
