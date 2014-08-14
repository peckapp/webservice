module SpecificScrape
  # scrapes William's dining menus
  # uses hard-coded values for the selectors and data_resources instead of database table information
  # this is done for now because dining menus are very specific to a certain school, and the most static of all
  class WilliamsAthletics
    include Sidekiq::Worker
    sidekiq_options queue: :scraping, retry: 5

    include Sidetiq::Schedulable
    recurrence { daily.hour_of_day(2) }

    EPH_SPORTS = 'http://ephsports.williams.edu/landing/index'

    def perform
      logger.info 'scraping Williams Athletic Events'

      raw = RestClient.get(EPH_SPORTS)
      html = Nokigiri::HTML(raw)
      store_url_keys(html)
    end # end perform method

    # stores all the URLS from the homepage of the athletics department
    def store_url_keys(html)
      html.css('div.pane ul li.has-submenu').each do |team|

      end
    end
  end # end WilliamsAthletics class
end # end SpecificScrape module
