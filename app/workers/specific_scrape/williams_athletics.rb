module SpecificScrape
  # scrapes William's dining menus
  # uses hard-coded values for the selectors and data_resources instead of database table information
  # this is done for now because dining menus are very specific to a certain school, and the most static of all
  class WilliamsAthletics
    include Sidekiq::Worker
    sidekiq_options queue: :scraping, retry: 5

    include Sidetiq::Schedulable
    recurrence { daily.hour_of_day(2) }

    EPH_SPORTS_ROOT = 'http://ephsports.williams.edu'
    EPH_SPORTS_INDEX = '/landing/index'

    def perform
      logger.info 'scraping Williams Athletic Events'

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
          team_name = team.css('a').first
          logger.info team_name

          team_links = team.css('div.secondary-links>ul>li')
          link = nil
          team_links.each do |tl|
            next unless tl.to_s.match(/schedule/)
            link = tl.css('a').first.values.first
            break
          end
          parse_scheule_page(link)
        end
      end
    end

    def parse_scheule_page(link)
      # raw = RestClient.get(rooted_link(link))
      # html = Nokogiri::HTML(raw)

      logger.info link
    end

    def rooted_link(ext)
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
