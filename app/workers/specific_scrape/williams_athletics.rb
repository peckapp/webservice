module SpecificScrape
  # scrapes William's dining menus
  # uses hard-coded values for the selectors and data_resources instead of database table information
  # this is done for now because dining menus are very specific to a certain school, and the most static of all
  class WilliamsAthletics
    include Sidekiq::Worker
    sidekiq_options queue: :scraping, retry: 5

    include Sidetiq::Schedulable
    # recurrence { weekly }

    # leave out of new_relic apdex score
    # newrelic_ignore_apdex

    EPH_SPORTS_ROOT = 'http://ephsports.williams.edu'
    EPH_SPORTS_INDEX = '/landing/index'

    def perform
      logger.info 'scraping Williams Athletic Events'

      rt = ResourceType.find_by(model_name: 'AthleticEvent')
      inst = Institution.find_by(api_key: 'WILLIAMS')
      @sr = ScrapeResource.current_or_create_new(resource_type_id: rt.id, institution_id: inst.id,
                                                 info: 'Williams Athletic RSS Team Page', kind: 'rss',
                                                 engine_type: 'nested')
      logger.info "Traversing Williams Athletics resource #{@sr.id} for RSS URLs with #{@sr.resource_urls.count} current"

      raw = RestClient.get(rooted_link(EPH_SPORTS_INDEX))
      html = Nokogiri::HTML(raw.squish)
      parse_url_keys(html)
    end # end perform method

    # stores all the URLS from the homepage of the athletics department
    def parse_url_keys(html)
      html.css('div#accordion-nav>a').each do |gender|
        category = gender.text.match(/.*? /).to_s.squish

        teams = next_non_blank(gender).css('li.has-submenu')
        logger.info "Traversing Williams Athletics category: #{category} with #{teams.count} teams"

        teams.each do |team|
          team_name = team.css('a').first.text

          team_img = team.css('div.secondary-links>img').first
          team_photo_url = rooted_link(team_img.attr('src')) if team_img

          team_links = team.css('div.secondary-links>ul>li')
          logger.error "NO LINKS FOUND for team: #{team_name}" if team_links.blank?
          link = nil
          team_links.each do |tl|
            next unless tl.to_s.downcase.match(/schedule/)
            link = tl.css('a').first.values.first
            break
          end
          sleep 0.5 + rand / 2
          parse_schedule_page(link, category, team_name, team_photo_url) if link
        end
      end
    end

    # each schedule page has a table of information on all the games for that season
    def parse_schedule_page(link, category, team_name, team_photo_url)
      full_link = rooted_link(link)
      full_link_rss = "#{full_link}?print=rss"

      logger.info "Scraping schedule for team: #{team_name}\twith link: #{full_link}"

      raw = RestClient.get(full_link)
      html = Nokogiri::HTML(raw)

      html.css('div.subscribe_links a').each do |a|
        url = rooted_link(a.values.first)
        next unless url && url.match(/rss/)

        # checks that the scraped url is in the expected rss format based on a manual page inspection
        logger.info "unexpected URL format: #{url} from full_link_rss: #{full_link_rss}" if url.downcase != full_link_rss.downcase

        # creates a resource url for the current scrape resource, which can in turn be scraped by the nested scraper
        team_name = "#{category} #{team_name}" unless team_name.match(/(M|m)en|(W|w)omen/)
        ateam = AthleticTeam.current_or_create_new(simple_name: team_name)
        ateam.image = URI.parse(team_photo_url)
        logger.info "saved AthleticTeam #{ateam.id} with image: #{ateam.image} for #{team_name}" if ateam.non_duplicative_save

        ru = ResourceUrl.new(url: url, scrape_resource_id: @sr.id, validated: true, scraped_value: team_name)

        logger.info "saved ResourceUrl #{ru.id} for #{team_name}" if ru.non_duplicative_save
      end

      # table = html.css('.schedule-content table')
      # parse_table(table)
    end

    # def parse_table(table)
    #   # gets all elements of any type with the current element as the parent
    #   immediate_children = table.css("#{table.css_path} > *")
    #
    #   immediate_children.each do |child|
    #     # parse the child rows to handle each type properly
    #     logger.info child.text
    #   end
    # end

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
