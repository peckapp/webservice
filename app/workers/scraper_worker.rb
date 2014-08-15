# This class iterates over the validated ScrapeResources

class ScraperWorker
  include Sidekiq::Worker
  sidekiq_options queue: :scraping

  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    resources = ScrapeResource.all

    # iterate over all resources
    resources.each do |resource|
      next unless resource.validated

      puts "handling validated resource: #{resource.inspect}"

      case resource.engine_type
      when 'nested'
        logger.info "handling scrape resource: #{resource.name} with nested scrape engine"
        handle_nested(resource)
      when 'simple'
        logger.info "handling scrape resource: #{resource.name} with simple scrape engine"
        handle_simple(resource)
      else
        logger.error "unable to handle scrape resource: #{resource.id} with engine type: #{resource.engine_type}"
      end

    end # end resources iteration
  end # end perform

  def handle_nested(resource)
  end

  def handle_simple(resource)
    # iterate over pages for that resource
    # need to find a way to explicate pagination movement.
    # may or may not need selenium, different url possibilities, form submissions, etc.
    # for now, this just looks at immediate url for the scrape resource
    (0..0).each do |_n| # placeholder page traversal

      # perform asynchronous worker task to scrape the page
      SimplePageScraper.perform_async(resource.id)

    end # end pagination traversal
  end
end
