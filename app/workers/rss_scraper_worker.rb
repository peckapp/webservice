class RssScraperWorker

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    Tasks::RssScraperController.scrape
  end

end
