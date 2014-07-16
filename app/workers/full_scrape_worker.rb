class FullScrapeWorker

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  PAGE_LIMIT = 30

  def perform(*attrs)
    attrs = attrs.extract_options!
    puts "attrs: #{attrs}"
    resources = ScrapeResource.where(attrs)

    # iterate over all resources
    resources.each do |resource|

      puts "resource: #{resource.inspect}"

      raw = RestClient::Request.execute(url: resource.url, method: :get, verify_ssl: false) # no dangerous security concern present here, possible data spoofing though

      html = Nokogiri::HTML(raw.squish)

      # iterate over pages for that resource
      # need to find a way to explicate pagination movement. may or may not need selenium, different url possibilities, form submissions, etc. may all be possible
      # for now just look at immediate url for the scrape resource
      (0..0).each do |n| # placeholder page traversal

        # down the road, extract html and send it off for parsing while continuing with pagination crawl

        top_selectors = Selector.where(id: resource.id, top_level: true)
        puts "found #{top_selectors.count} top selectors"
        top_selectors.each do |ts|

          puts "ts: #{ts.inspect}"

          # an array of all the top-level items for a given tag. these are nokogiri nodes
          html_items = html.css(ts.selector)

          html_items.each do |html_item| # iterates over Nokogiri nodeset for given css selector

            new_model = ts.model.new

            # traverse all children for a given selector
            ts.children.each do |cs|

              puts "cs: #{cs.inspect}"

              content_item = html_item.css(cs.selector).first

              if ! content_item.blank?
                content = content_item.text.squish # assumes there is only one element, could iterate instead but then where does that information go?
                if content.blank?
                  content = next_non_blank(content_item).text.squish
                end
                puts "CONTENT: #{content}"
                new_model.assign_attributes(cs.column_name => content)
              else
                puts "NO CONTENT FOUND"
              end
            end

            # validate new model

            puts "new_model ---> #{new_model.inspect}"
            # new_model.non_duplicative_save

          end # end items iteration

        end # end selector iteration
      end # end page iteration
    end # end resources do


  end # end perform

  def next_non_blank(elem)
    until ! elem.text.blank? do
      elem = elem.next
    end
    elem
  end

end
