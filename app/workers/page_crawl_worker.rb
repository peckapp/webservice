# This worker continues the task for an individual page that is being crawled
# the end goal is to put information into the database that can be used to repeatedlt scrape the page in the future
# this worker may handle page type analysis and extraction of xpaths in the future

# currently, it handles the simple cases of storing urls as ScrapingResources for rss feeds and webcal services

class PageCrawlWorker

  include Sidekiq::Worker

  def perform(url, inst_id)

    uri = URI(url)

    if uri.to_s.match(/rss/)
      # input url into database with type 'rss'
      resc = ScrapeResource.new(url: url, institution_id: inst_id, info: "rss")
      resc.non_duplicative_save

    elsif uri.scheme.match(/webcal/) || uri.to_s.match(/\.ics$/) # matches webcal schemes and .ics filetypes
      resc = ScrapeResource.new(url: url, institution_id: inst_id, info: "webcal")
      resc.non_duplicative_save

    else
      # page wasn't rss or webcal, handle other types here if necessary
    end
  end

end
