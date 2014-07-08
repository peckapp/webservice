# this class handles the main crawl loop and dispatches other workers to parse individual pages

class CrawlerWorker

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  QUEUE_NAME = "general_crawl"

  recurrence { daily }

  def perform

  end

  private

    def crawl_loop
      
    end

end
