module SpecificScrape
  # scrapes Middlebury's dining menus
  # uses hard-coded values for the selectors and data_resources instead of database table information
  # this is done for now because dining menus are very specific to a certain school, and the most static of all
  class WilliamsDining
    include Sidekiq::Worker
    sidekiq_options queue: :scraping, retry: false

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
      top_selectors = Selector.where(scrape_resource_id: sr_id, top_level: true).to_a

      while top_selectors.any?
        ts = top_selectors.pop

        if ts.parent
          logger.info "clicking parent selector: #{ts.parent.selector}"
          b.link(text: ts.parent.selector).click
          be_nice
        end

        logger.info "clicking selector: #{ts.selector}"
        b.link(text: ts.selector).click
        be_nice

        children = ts.children
        children.each do |child|
          logger.info "handling child with selector: #{child.selector}"
          # because williams uses a variable level of nesting in their menu display, we have to dig to the lowest level
          if ts.data_resource == child.data_resource
            # if the child has the same data resource as the parent (both DiningPlace), add it back to the list
            logger.info 'adding child back to top selectors'
            top_selectors.push child
          else
            dining_place = DiningPlace.current_or_create_new(name: ts.selector, institution_id: inst_id)

            # for williams, at every specific place there is a table of days with meals inside of them
            logger.info "clicking child: #{child.selector}"
            b.link(text: child.selector).click
            be_nice
            scrape_dates(b, dining_place, inst_id, sr_id)
            logger.info 'done scraping dates'
            be_nice
            go_back(b)
          end
        end # end child iteration
        go_back(b)
      end # end top selector iteration
    end

    # scrapes dates using built-in css selectors since these are the same for each page
    def scrape_dates(b, place_id, inst_id, sr_id)
      logger.info "scraping dates for #{b.tds(css: 'tr .cbo_nn_menuCell').count} cells"
      # iterates over the cells for each day
      cell_max = b.tds(css: 'tr .cbo_nn_menuCell').count
      (1..cell_max).each do |i|
        cell = b.tds(css: 'tr .cbo_nn_menuCell')[i - 1]
        logger.info 'starting date iteration'
        date = cell.td.text
        logger.info "iterating over date #{date} with #{cell.tds(css: '.cbo_nn_menuLink').count} links"

        link_max = cell.tds(css: '.cbo_nn_menuLink').count
        (1..link_max).each do |j|
          # must be refreshed after any page navigation
          cell = b.tds(css: 'tr .cbo_nn_menuCell')[i - 1]
          opp_link = cell.tds(css: '.cbo_nn_menuLink')[j - 1]

          logger.info "opp_link: #{opp_link}"
          opp_type = opp_link.text.downcase.camelize # creates a properly cased version of the dining opportunity
          # opp = DiningOpportunity.current_or_create_new(institution_id: inst_id, dining_opportunity_type: opp_type)

          logger.info "clicking on link type: #{opp_type}"
          opp_link.click
          be_nice
          scrape_items_from_opportunity(panel_html, opp.id, date, place_id, inst_id, sr_id)
          be_nice
          go_back(b)
          logger.info 'iterating over dining opportunities'
        end
      end
    end

    # passed in the html for the panel to be parsed as well as the necessary parameters for menu item creation
    def scrape_items_from_opportunity(b, opp_id, date, place_id, inst_id, sr_id)
      html = Nokogiri::HTML(b.table(css: '.cbo_nn_itemGridTable').html)
      logger.info "scraping items from opportunity with id: #{opp_id}"
      category_name = nil
      html.css('tr').each do |row|
        if row.css('.cbo_nn_itemGroupRow').count > 0 # update category during iteration
          category_name = row.text
        elsif row.css('.cbo_nn_itemHover').count > 0 # create menu item with current category
          mi = MenuItem.new(institution_id: inst_id, name: row.text, dining_opportunity_id: opp_id,
                            dining_place_id: place_id, date_available: date, category: category_name)
          logger.info "created valid menu item? #{mi.valid?}"
        end
      end
    end

    def go_back(b)
      logger.info 'backin\' it up'
      button = b.button(css: '.cbo_nn_backButton')
      button.click if button.exists?
      be_nice
    end

    def be_nice
      logger.info 'sleeping...'
      # sleeps so as to avoid blasting requests repeatedly in a row
      sleep 1.0 + rand
    end
  end
end
