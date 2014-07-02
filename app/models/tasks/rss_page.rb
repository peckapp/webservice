class Tasks::RssPage < ActiveRecord::Base

  self.table_name = 'rss_pages'

  ### institution for the page
  belongs_to :institution

end
