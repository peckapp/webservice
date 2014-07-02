class Tasks::RssScraperController < ApplicationController

  def scrape
    Tasks::RssPage.all.each { |page|
      parse_and_store(page.url, page.institution_id)
    }
  end

  private

    def parse_and_store(url,institution_id)
      feed = Feedjira::Feed.fetch_and_parse(url)

      feed.entries.each { |entry|

        se = SimpleEvent.new

        se.title = entry.title
        se.institution_id = institution_id
        se.event_url = entry.url
        se.description = entry.summary.squish

        html = Nokogiri::HTML(entry.summary)

        html.xpath("//b").each { |t|
          val = t.next.text.match(/[[:alnum:]]/) ? t.next : t.next.next
          entry_h[:summary][t.text] = val.text
        }

      }
    end

end
