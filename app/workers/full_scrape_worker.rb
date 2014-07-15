class FullScrapeWorker

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform(*attrs)
    attrs = attrs.extract_options!
    resources = ScrapeResources.where(attrs)

    resources.each do |resource|
      
    end # end resources do
  end # end perform

end
