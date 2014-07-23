# This class iterates over the validated ScrapeResources

class ScraperWorker

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform(*attrs)
    attrs = attrs.extract_options!
    puts "attrs: #{attrs}"
    resources = ScrapeResource.where(attrs)

    # iterate over all resources
    resources.each do |resource|
      next unless resource.validated


      # iterate over pages for that resource
      # need to find a way to explicate pagination movement.
      # may or may not need selenium, different url possibilities, form submissions, etc.
      # for now, this just looks at immediate url for the scrape resource
      (0..0).each do |n| # placeholder page traversal

        # perform asynchronous worker task to scrape the page
        SimplePageScraper.perform_async(resource.id)

      end # end pagination traversal

    end # end resources iteration

  end # end perform

end
