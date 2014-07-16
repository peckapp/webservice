class DropRssPages < ActiveRecord::Migration
  def up
    drop_table :rss_pages
  end

  def down
    create_table :rss_pages do |t|
      t.integer 'institution_id', :null => false
      t.string 'url', :null => false
      t.integer 'scrape_interval', default: 1440
      t.boolean 'paginated', default: false

      t.timestamps
    end
  end
end
