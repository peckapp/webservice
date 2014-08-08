module SpecificScrape
  # scrapes middlebury's dining menus
  # uses hard-coded values for the selectors and data_resources instead of database table information
  # this is done for now because dining menus are very specific to a certain school, and the most static of all
  class MiddDining
    include Sidekiq::Worker
    # turn off retry for development
    sidekiq_options retry: false
    include Sidetiq::Schedulable

    recurrence { daily.hour_of_day(2) }

    MIDD_MENUS = 'http://menus.middlebury.edu'
    DATE_FORMAT = '%A, %B %-d, %Y'

    def perform
      midd = Institution.where(api_key: 'MIDDLEBURY').first
      resource_type = ResourceType.where(resource_name: 'menu_item').first
      if midd.blank? || resource_type.blank?
        logger.error 'Either \'middlebury college\' institution or \'menu_item\' resource not found for dining scrape'
        return
      end
      resources = ScrapeResource.where(resource_type_id: resource_type.id, validated: true, institution_id: midd.id)
      logger.info "found #{resources.count} resources"
      if resources.blank?
        logger.warn 'No scrape resources for middlebury dining menus'
        resources << ScrapeResource.current_or_create_new(url: MIDD_MENUS, institution_id: midd.id,
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
          logger.info 'entering middlebury dining scraping loop'
          scrape_forward(b, inst_id)
        end
      rescue => error
        raise error
      ensure
        b.close
        headless.destroy
      end
    end

    def scrape_forward(b, inst_id)
      (0..7).each do |increment|

        logger.info "scraping midd dining for #{increment} days from now"

        date = Date.current + increment
        date_str = date.strftime(DATE_FORMAT)
        date_field = b.text_field name: 'field_day_value[value][date]'
        logger.error 'middlebury dining date_field not found' if date_field.blank?
        date_field.set date_str

        apply_button = b.button id: 'edit-submit-menus-test'
        apply_button.click

        data = b.div class: 'view view-menus-test view-id-menus_test view-display-id-page'

        if data.exists?
          html_raw = data.html
          scrape_html(html_raw.squish, date, inst_id)
        else
          logger.error 'Middlebury dining information not found at specified CSS selectors'
          # one in place, trigger the analysis phase of the webpage once again
        end

        sleep 1 + rand

      end
    end

    def scrape_html(html_raw, date, inst_id, sr_id)
      html = Nokogiri::HTML(html_raw)

      html.css("table[class*='views-view-grid']").each do |table|

        place_name = table.previous.previous.text
        place = DiningPlace.current_or_create_new(institution_id: inst_id, name: place_name)

        table.css('td').each do |entry|
          opportunity_type = entry.css('span[class=field-content]').text
          opportunity = DiningOpportunity.current_or_create_new(institution_id: inst_id,
                                                                dining_opportunity_type: opportunity_type)

          entry.css('p').children.each do |item|
            if item.text.blank?
              logger.warn 'skipped blank menu_item entry at css selector \'p\''
              next
            end

            item_name = item.text
            mi = MenuItem.new(name: item_name, dining_opportunity_id: opportunity.id, dining_place_id: place.id,
                              date_available: date, scrape_resource_id: sr_id)
            logger.info "menu item: #{mi.inspect}"

          end # end entry items

        end # end table entries

      end # end tables
    end
  end
end
