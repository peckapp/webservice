class CreateResourceUrls < ActiveRecord::Migration
  def change
    create_table :resource_urls do |t|
      t.string 'url', null: false
      t.string 'info'
      t.integer 'scrape_resource_id', null: false

      t.timestamps
    end
  end
end
