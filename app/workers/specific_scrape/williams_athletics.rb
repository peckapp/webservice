module SpecificScrape
  # scrapes William's dining menus
  # uses hard-coded values for the selectors and data_resources instead of database table information
  # this is done for now because dining menus are very specific to a certain school, and the most static of all
  class WilliamsAthletics
    include Sidekiq::Worker
    sidekiq_options queue: :scraping, retry: 5

    include Sidetiq::Schedulable
    # recurrence { daily.hour_of_day(2) }

    EPH_SPORTS_ROOT = 'http://ephsports.williams.edu'
    EPH_SPORTS_INDEX = '/landing/index'

    def perform
      logger.info 'scraping Williams Athletic Events'

      rt = ResourceType.where(model_name: 'AthleticEvent').first
      inst = Institution.where(api_key: 'WILLIAMS').first
      @sr = ScrapeResource.current_or_create_new(resource_type_id: rt.id, institution_id: inst.id,
                                                 info: 'Williams Athletic Team Page', kind: 'rss', engine_type: 'nested')
      logger.info "scrape resource: #{@sr}"

      raw = RestClient.get(rooted_link(EPH_SPORTS_INDEX))
      html = Nokogiri::HTML(raw.squish)
      parse_url_keys(html)
    end # end perform method

    # stores all the URLS from the homepage of the athletics department
    def parse_url_keys(html)
      html.css('div#accordion-nav>a').each do |gender|
        category = gender.text
        logger.info "category: #{category}"

        teams = next_non_blank(gender).css('li.has-submenu')
        logger.info teams.count
        teams.each do |team|
          team_name = team.css('a').first.text
          logger.info "team_name: #{team_name}"

          team_links = team.css('div.secondary-links>ul>li')
          link = nil
          team_links.each do |tl|
            # logger.info "team link: #{tl}"
            next unless tl.to_s.match(/schedule/)
            link = tl.css('a').first.values.first
            break
          end
          sleep 0.5 + rand / 2
          parse_schedule_page(link, team_name) if link
        end
      end
    end

    # each schedule page has a table of information on all the games for that season
    def parse_schedule_page(link, team_name)
      logger.info link
      full_link = rooted_link(link)
      full_link_rss = "#{full_link}?print=rss"

      logger.info "parsing schedule with link: #{full_link}"

      raw = RestClient.get(full_links)
      html = Nokogiri::HTML(raw)

      html.css('div.subscribe_links a').each do |a|
        url = rooted_link(a.values.first)
        next unless url && url.match(/rss/)

        logger.info "unexpected URL format: #{url} from full_link_rss: #{full_link_rss}" if url != full_link_rss

        # creates a resource url for the current scrape resource, which can in turn be scraped by the nested scraper
        ru = ResourceUrl.current_or_create_new(url: url, scrape_resource_id: @sr.id)

        logger.info "#{team_name}: #{ru}"
      end

      # table = html.css('.schedule-content table')
      # parse_table(table)
    end

    def parse_table(table)
      # gets all elements of any type with the current element as the parent
      immediate_children = table.css("#{table.css_path} > *")

      immediate_children.each do |child|
        # parse the child rows to handle each type properly
        logger.info child.text
      end
    end

    def rooted_link(ext)
      return ext if ext && ext.match(/\Ahttps?:/)
      "#{EPH_SPORTS_ROOT}#{ext}"
    end

    def next_non_blank(elem)
      loop do
        elem = elem.next
        break unless elem.text.blank?
      end
      elem
    end
  end # end WilliamsAthletics class
end # end SpecificScrape module
