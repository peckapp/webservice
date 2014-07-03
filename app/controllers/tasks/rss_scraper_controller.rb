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

      feed.xpath('//rss/channel/item').each { |item|

        se = SimpleEvent.new

        se.institution_id = institution_id

        item.children.each { |child|
          next if child.blank?

          if child.class == Nokogiri::XML::Element then
            insert_property_into_event(child,event)
          else
            puts "unexpected child type: #{child.class}"
          end
        }

      }

    end

    def insert_property_into_event(property,event)
      name = property.name

      if name.match(/title/)
        event.title = property.content.squish

      elsif name.match(/description/)
        se.description = preperty.content.squish

      elsif name.match(/link/)
        # williams' link html seems to be broken and missing a close tag, this handles that error
        link = item.css('link').first.text.squish
        if link != ""
          se.event_url = link
        else
          se.event_url = item.css('link').first.next.text.squish
        end

      elsif name.match(/latitude|lat/)
        event.latitude = property.content.to_f

      elsif name.match(/longitude|lng/)
        event.longitude = property.content.to_f

      end

      puts "filled event: #{event}"

    end

end
