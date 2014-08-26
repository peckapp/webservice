# Built off the foundation of the NestedScraper which was becoming bloated

# still runs on the assumption that each model is contained within a single top selector

# a worker using database information to scrape structured data off of websites
# correctly handles rss feeds in any format, but untested elsewhere
# relies on a nested structure of the html content
class NestedTraverseScraper
  include Sidekiq::Worker
  sidekiq_options queue: :scraping, retry: 5

  # leave out of new_relic apdex score
  # newrelic_ignore_apdex

  PAGE_LIMIT = 30

  def perform(resource_id)
    logger.error "NestedScraper passed #{resource_id} requires a valid id as a parameter" if resource_id < 1
    return if resource_id < 1

    resource = ScrapeResource.find(resource_id)
    logger.info "Scraping nested resource #{resource.id}: '#{resource.info}' with #{resource.resource_urls.count} urls"

    count = resource.resource_urls.reduct(0) do |acc, r_url|
      # no dangerous security concern present here with skipped ssl verification, possible data spoofing though
      raw = RestClient::Request.execute(url: r_url.url, method: :get, verify_ssl: false)

      html = Nokogiri::HTML(raw.squish)

      acc + (index_page_scrape(html, r_url, resource) || 0)

    end # end resource_url iteration
    logger.info "Saved #{count} new valid models for resource #{resource.id} with #{resource.resource_urls.count} urls"
  end # end perform

  ##############################################
  ###  Scraping the index page for an event  ###
  ##############################################

  def index_page_scrape(html, r_url, resource)
    count = 0
    top_selectors = Selector.where(scrape_resource_id: resource.id, top_level: true)
    logger.error "Scrape Resource #{resource.id} has no top_level Selectors (url: #{r_url.url})" if top_selectors.count == 0
    top_selectors.each do |ts|
      # an array of all the top-level items for a given tag. these are nokogiri nodes
      blocks = html.css(ts.selector)

      blocks.each do |block| # iterates over Nokogiri nodeset for given css selector

        # creates a model with scrape resource info set
        new_model = ts.model.new(scrape_resource_id: resource.id,
                                 institution_id: resource.institution_id,
                                 url: r_url.url,
                                 public: true)

        iterate_children(ts, block, new_model)

        # saves new model and increments count if it was inputted
        count += 1 if validate_and_save(new_model)
      end # end items iteration
    end # end selector iteration
    count
  end

  # traverse all children for a given top selector
  def iterate_children(ts, block, new_model)
    logger.error "top selector #{ts.id} for resource #{resource.id} has no children" if ts.children.count == 0
    ts.children.each do |cs|
      # logger.info "child selector: #{cs.selector}"

      # assumes there is only one element - could iterate instead but what case would that be?
      content_item = block.css(cs.selector).first

      if !content_item.blank?
        unless cs.data_resource_id
          logger.error "no data resource for selector #{cs.id} with found content"
          next
        end

        content = content_item.text.squish
        content = next_non_blank(content_item).text.squish if content.blank?
        if cs.foreign_key?
          # logger.info "handling foreign key for selector: #{cs.inspect}"

          # finds the current model matching the single found parameter or creates a new one
          foreign_resource = cs.foreign_data_resource
          next unless foreign_resource

          # for now, completed ignore scraped value for foreign key because the only use case is athletic events which can be parsed from it.
          # this is a shitty hack that needs to be rectified before moving on. Handling foreign keys probably
          # requires a re-write because they go far beyond the original design and purpose of this class.
          content = r_url.scraped_value # unless content.match(/^[A-Za-z ']*$/)

          content_model = foreign_resource.minimal_current_or_new(content)
          content_model[:institution_id] = resource.institution_id

          # models for foreign key content must be saved just as any other model
          validate_and_save(content_model)
          # logger.info "found content_model for selector cs.id: #{content_model.inspect}"
          new_model.assign_attributes(cs.column_name => content_model.id)
        else
          # assign the text-based content to the proper column of the model
          new_model.assign_attributes(cs.column_name => content)
        end
      else
        logger.warn "NO CONTENT FOUND for top selector: #{ts.selector} and child selector: #{cs.selector}"
      end
    end # end top selector children iteration
  end

  ###############################################
  ###  Scraping the detail page for an event  ###
  ###############################################

  def detail_page_scrape

  end

  ### Handling completed or partial models ###

  def validate_and_save(new_model)
    # will need to check for partial matches that could indicate a change in the displayed content
    # may also need to delete events that are no longer in the feed if they are determined to have been cancelled

    # if model is invalid using built-in validations, attempt to repair it
    Reparator.repair_model(new_model) unless new_model.valid?

    # clear errors to retry validations after attempted fixes
    new_model.errors.clear
    # perform save
    if new_model.valid?
      # performs non-duplicative save
      if new_model.non_duplicative_save
        # logger.info "Saved validated model of type '#{new_model.class}' with id: #{new_model.id}\n"
        return true
      end
    else
      # logger.info new_model.start_time.class
      logger.warn "failed to save model with errors #{new_model.errors.messages} and data: #{new_model.inspect}\n"
    end
    false
  end

  def next_non_blank(elem)
    elem = elem.next while elem.text.blank?
    elem
  end
end
