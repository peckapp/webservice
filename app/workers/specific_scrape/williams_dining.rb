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
    def scrape_places(b, inst_id, sr_id)
      top_selectors = Selector.where(scrape_resource_id: sr_id, top_level: true)

      top_selectors.each do |ts|
        b.link(text: ts.selector).click

        children = ts.children
        children.each do |child|
          # because williams uses a variable level of nesting in their menu display, we have to dig to the lowest level
          if ts.data_resource == child.data_resource
            # if the child has the same data resource as the parent (both DiningPlace), add it back to the list
            top_selectors << child
          else
            dining_place = DiningPlace.current_or_create_new(name: ts.selector, institution_id: inst_id)

            # for williams, at every specific place there is a table of days with meals inside of them
            b.link(ts.selector).click
            scrape_dates(b, dining_place, inst_id, sr_id)
          end
          be_nice
        end # end child iteration
        be_nice
      end # end top selector iteration
    end

    # scrapes dates using built-in css selectors since these are the same for each page
    def scrape_dates(b, place_id, inst_id, sr_id)
      # iterates over the cells for each day
      b.trs(css: '.cbo_nn_menuCell').each do |cell|
        date = cell.td.text
        # should only be one
        cell.tds(css: '.cbo_nn_menuLink').each do |opp_link|
          opp_type = opp_link.text.downcase.camelize # creates a properly cased version of the dining opportunity
          opp = DiningOpportunity.current_or_create_new(institution_id: inst_id, dining_opportunity_type: opp_type)

          opp_link.click
          panel_html = b.table(css: '.cbo_nn_itemGridTable').html
          scrape_items_from_opportunity(panel_html, opp_id, date, place_id, inst_id, sr_id)
          go_back(b)
        end

      end
      be_nice
    end

    # passed in the html for the panel to be parsed as well as the necessary parameters for menu item creation
    def scrape_items_from_opportunity(panel_html, opp_id, date, place_id, inst_id, sr_id)
      html = Nokigiri::HTML(panel_html)

      category_name = nil
      html.css('tr').each do |row|
        if row.css('.cbo_nn_itemGroupRow').count > 0 # update category during iteration
          category_name = row.text
        elsif row.css('.cbo_nn_itemHover').count > 0 # create menu item with current category
          MenuItem.new(institution_id: inst_id, name: row.text, opportunity_id: opp_id,
                       date: date, category: category_name)
        end

      end
    end

    def go_back(b)
      b.button(id: 'btn_BackmenuList').click
    end

    def be_nice
      # sleeps so as to avoid blasting requests repeatedly in a row
      sleep 1.0 + rand
    end
  end
end
