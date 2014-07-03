class Tasks::RssScraperController < ApplicationController

  require 'date'

  def scrape
    puts "in scrape method"
    Tasks::RssPage.all.each { |page|
      parse_and_store(page.url, page.institution_id)
    }
  end

  private

    def parse_and_store(url,institution_id)
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

        non_duplicative_save(event, {title: event.title, start_date: event.start_date})

      }

    end

    def insert_property_into_event(property,event)
      name = property.name

      if name.match(/title/)
        event.title = property.content.squish

      elsif name.match(/description/)
        event.event_description = property.content.squish

      elsif name.match(/pubDate/)
        event.start_date = DateTime.parse(property.content)

      elsif name.match(/link/)
        # williams' link html seems to be broken and missing a close tag, this handles that error
        link = item.css('link').first.text.squish
        if link != ""
          event.event_url = link
        else
          event.event_url = property.css('link').first.next.text.squish
        end

      elsif name.match(/latitude|lat/)
        event.latitude = property.content.to_f

      elsif name.match(/longitude|lng/)
        event.longitude = property.content.to_f

      end

      puts "filled event: #{event.inspect}"

    end

    

end
