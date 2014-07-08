class RssScraperWorker

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely }

  def perform
    Tasks::RssScraperController.scrape
  end

end
