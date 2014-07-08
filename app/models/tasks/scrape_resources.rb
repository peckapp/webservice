class Tasks::ScrapeResources < ActiveRecord::Base

  self.table_name = "scrape_resources"

  set_fixture_class :scrape_resources => "Tasks::ScrapeResources"

end
