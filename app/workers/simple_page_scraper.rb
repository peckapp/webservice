# Based off the experimental NestedScrapeWorker, this class will use information from the databse to handle
# a wider range of page types, including situations where siblings in the HTML structure belong to the same object
# it is not a scheduable sidetiq job, but rather a worker on a single page that is spawned by iterative workers

class SimplePageScraper

  include Sidekiq::Worker

  PAGE_LIMIT = 30

  def perform(resource_id)

    resource = ScrapeResource.find(resource_id)

    puts "resource: #{resource.inspect}"

    raw = RestClient::Request.execute(url: resource.url, method: :get, verify_ssl: false) # no dangerous security concern present here, possible data spoofing though

    html = Nokogiri::HTML(raw.squish)

    # down the road, extract html and send it off for parsing while continuing with pagination crawl

    top_selectors = Selector.where(id: resource.id, top_level: true)
    puts "found #{top_selectors.count} top selectors"
    top_selectors.each do |ts|

      puts "top selector: #{ts.selector}"

      # an array of all the top-level items for a given tag. these are nokogiri nodes
      html_items = html.css(ts.selector)

      html_items.each do |html_item| # iterates over Nokogiri nodeset for given css selector

        puts "\ncreating new model"
        new_model = ts.model.new

        # traverse all children for a given selector
        ts.children.each do |cs|

          puts "child selector: #{cs.selector}"

          # assumes there is only one element – could iterate instead but then where would that information go?
          content_item = html_item.css(cs.selector).first

          if ! content_item.blank?
            content = content_item.text.squish
            if content.blank?
              content = next_non_blank(content_item).text.squish
            end
            puts " ==> CONTENT: #{content}"
            new_model.assign_attributes(cs.column_name => content)
          else
            puts " ==> NO CONTENT FOUND"
          end
        end

        validate_and_save(new_model)

      end # end items iteration

    end # end selector iteration

  end # end perform

  def validate_and_save(model)

    # validate new model

    # check for partial matches that could indicate a change in the displayed content

    puts "new_model ---> #{model.inspect}"
    model.non_duplicative_save

  end

  def next_non_blank(elem)
    until ! elem.text.blank? do
      elem = elem.next
    end
    elem
  end

end
