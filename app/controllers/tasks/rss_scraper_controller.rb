# deprecated class in favor of workers. just here for a bit longer as reference until new system work for rss

class Tasks::RssScraperController < ApplicationController

  require 'date'

  def self.scrape
    puts "in scrape method"
    # Tasks::RssPage.all.each { |page|
    #   parse_and_store(page.url, page.institution_id)
    # }
  end

  private

    def self.parse_and_store(url,institution_id)
      # feed = Feedjira::Feed.fetch_and_parse(url)
      puts "in parse_and_store"

      page = Nokogiri::XML(RestClient.get(url))

      page.xpath('//rss/channel/item').each { |item|

        event = SimpleEvent.new

        event.institution_id = institution_id

        item.children.each { |child|

          next if child.blank?

          if child.class == Nokogiri::XML::Element then
            insert_property_into_event(child,event)
          else
            puts "unexpected child type: #{child.class}"
          end
        }
        # a start_date is required
        next if event.start_date.blank?

        # if end_date is null, give the event a default length of an hour
        if event.end_date.blank?
          # adds an hour to start_date
          event.end_date = event.start_date.advance( hours: 1 )
        end

        # explicitely specify the sole attributes needed to uniquely identify events. ignores description and other changes for now
        result = event.non_duplicative_save(title: event.title, start_date: event.start_date, institution_id: event.institution_id)

        if result then puts "filled event: #{event.inspect}" else puts "event #{event.inspect} was a duplicate" end
      }

    end

    def self.insert_property_into_event(property,event)
      name = property.name

      if name.match(/title/)
        event.title = property.content.squish

      elsif name.match(/description/)
        event.event_description = property.content.squish

      elsif name.match(/pubDate/)
        event.start_date = DateTime.parse(property.content)

      elsif name.match(/link/)
        puts property.to_html
        # williams' link html seems to be broken and missing a close tag, this handles that error
        link_elem = property.css('link')
        if ! link_elem.blank?
          # standard situation where the text of the element is the link
          link = link_elem.first.text.squish

          if link.blank?
            # another attempt that gets the next element, done this way due to strange parsing results in testing
            link = property.css('link').first.next.text.squish
          end

          if ! link.blank? && link.uri? then event.event_url = link end
        end

      elsif name.match(/latitude|lat/)
        event.latitude = property.content.to_f

      elsif name.match(/longitude|lng/)
        event.longitude = property.content.to_f

      end

    end

    def self.uri?(string)
      uri = URI.parse(string)
      %w( http https ).include?(uri.scheme)
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
    end

end
