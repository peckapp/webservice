class FullScrapeWorker

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  PAGE_LIMIT = 30

  def perform(*attrs)
    attrs = attrs.extract_options!
    resources = ScrapeResources.where(attrs)

    # iterate over all resources
    resources.each do |resource|

      raw = RestClient.get(resource.url)

      html = Nokogiri::HTML(raw)



      # iterate over pages for that resource
      # need to find a way to explicate pagination movement. may or may not need selenium, different url possibilities, form submissions, etc. may all be possible
      # for now just look at immediate url for the scrape resource
      (0..0).each do |n| # placeholder page traversal

        # down the road, extract html and send it off for parsing while continuing with pagination crawl

        top_selectors = Selector.where(id: resource.id, top_level: true)
        top_selectors.each do |ts|

          # an array of all the top-level items for a given tag. these are nokogiri nodes
          html_items = html.css(ts.selector)

          html_items.each do |html_item| # iterates over Nokogiri nodeset for given css selector

            new_model = ts.model.new

            # resursively traverse all children for a given selector
            ts.children.each do |cs|

              content_item = html_item.css(cs.selector).first.text.squish # assumes there is only one element, could iterate instead but then where does that information go?s

              new_model.assign_attributes(cs.column_name => content_item)

            end

            # validate new model

            puts "new_model =>\n#{new_model}"
            # new_model.non_duplicative_save

          end # end items iteration

        end # end selector iteration
      end # end page iteration
    end # end resources do


  end # end perform

end
