class CreateCrawlSeeds < ActiveRecord::Migration
  def change
    create_table :crawl_seeds do |t|
      t.string :info
      t.string :url
      t.string :regex
      t.boolean :active
      t.integer :institution_id

      t.timestamps
    end
  end
end
