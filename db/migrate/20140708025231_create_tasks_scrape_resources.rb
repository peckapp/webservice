class CreateTasksScrapeResources < ActiveRecord::Migration
  def change
    create_table :scrape_resources do |t|
      t.string  :url,             null: false
      t.integer :institution_id,  null: false
      t.string  :resource_type,   null: false
      t.integer :scrape_interval, default: 1440
      t.boolean :validated,       default: false

      t.timestamps
    end
  end
end
