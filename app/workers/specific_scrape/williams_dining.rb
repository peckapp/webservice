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
      williams = Institution.where(api_key: 'WILLIAMS').first
      resource_type = ResourceType.where(resource_name: 'menu_item').first
      if williams.blank? || resource_type.blank?
        logger.error 'Either \'WILLIAMS\' institution or \'menu_item\' resource not found for dining scrape'
        return
      end
      resources = ScrapeResource.where(resource_type_id: resource_type.id, validated: true, institution_id: williams.id)
      logger.info "found #{resources.count} resources"
      if resources.blank?
        logger.warn 'No scrape resources for middlebury dining menus'
        resources << ScrapeResource.current_or_create_new(url: WILLIAMS_MENUS, institution_id: williams.id,
                                                          resource_type_id: resource_type.id)
      end

      logger.info 'creating headless watir browser'
      headless = Headless.new
      headless.start
      b = Watir::Browser.new

      begin
        resources.each do |r|
          logger.info "scraping resource #{r.id}: #{r.kind}, #{r.info}"
          b.goto r.url
          logger.info 'entering williams dining scraping loop'
          scrape_places(b, williams.id, r.id)
        end
      rescue => error
        raise error
      ensure
        b.close
        headless.destroy
      end
    end

    #
    def scrape_places(d, inst_id, sr_id)

    end
  end
end
