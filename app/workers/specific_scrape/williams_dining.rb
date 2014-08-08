module SpecificScrape
  # scrapes middlebury's dining menus
  # uses hard-coded values for the selectors and data_resources instead of database table information
  # this is done for now because dining menus are very specific to a certain school, and the most static of all
  class MiddDining
    include Sidekiq::Worker
    sidekiq_options queue: :scraping

    include Sidetiq::Schedulable
    recurrence { daily.hour_of_day(2) }

    WILLIAMS_MENUS = 'http://nutrition.williams.edu/NetNutrition/Home.aspx'

    def perform

    end

  end
end
