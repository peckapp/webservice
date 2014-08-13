module SpecificScrape
  # scrapes middlebury's dining menus
  # uses hard-coded values for the selectors and data_resources instead of database table information
  # this is done for now because dining menus are very specific to a certain school, and the most static of all
  class MiddDining
    include Sidekiq::Worker
    sidekiq_options queue: :scraping

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
          scrape_forward(b, midd.id, r.id)
        end
      rescue => error
        raise error
      ensure
        b.close
        headless.destroy
      end
    end

    def scrape_forward(b, inst_id, sr_id)
      (0..7).each do |increment|

        logger.info "scraping midd dining for #{increment} days from now"

        date = Date.current + increment
        date_str = date.strftime(DATE_FORMAT)
        date_field = b.text_field name: 'field_day_value[value][date]'
        logger.error 'middlebury dining date_field not found' if date_field.blank?
        date_field.set date_str

        logger.info 'set date field'

        apply_button = b.button id: 'edit-submit-menus-test'
        apply_button.click

        logger.info 'clicked "apply" button'

        data = b.div class: 'view view-menus-test view-id-menus_test view-display-id-page'

        if data.exists?
          html_raw = data.html
          scrape_html(html_raw.squish, date, inst_id, sr_id)
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
        logger.info "scraping place: #{place_name}"

        table.css('td').each do |entry|
          opportunity_type = entry.css('span[class=field-content]').text
          opportunity = DiningOpportunity.current_or_create_new(institution_id: inst_id,
                                                                dining_opportunity_type: opportunity_type)
          count = 0
          entry.css('p').children.each do |item|
            next if item.text.blank?

            item_name = item.text
            mi = MenuItem.new(name: item_name, dining_opportunity_id: opportunity.id, dining_place_id: place.id,
                              institution_id: inst_id, date_available: date, scrape_resource_id: sr_id)
            unless mi.valid?
              logger.warn "invalid menu item with warnings: #{mi.errors.messages}"
            end
            count += 1 if mi.non_duplicative_save

          end # end entry items
          logger.info "saved #{count} new menu items for opportunity #{opportunity_type} and place #{place_name}"

        end # end table entries

      end # end tables
    end
  end
end
