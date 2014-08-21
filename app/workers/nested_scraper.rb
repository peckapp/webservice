# a worker using database information to scrape structured data off of websites
# correctly handles rss feeds in any format, but untested elsewhere
# relies on a nested structure of the html content
class NestedScraper
  include Sidekiq::Worker
  sidekiq_options queue: :scraping, retry: 5

  include Sidetiq::Schedulable

  # recurrence { daily }

  PAGE_LIMIT = 30

  def perform(resource_id)
    resource = ScrapeResource.find(resource_id)

    logger.info "Scraping nested resource #{resource.id} with #{resource.resource_urls.count} urls and info: #{resource.info}"

    count = 0
    resource.resource_urls.each do |r_url|
      url = r_url.url
      # no dangerous security concern present here with skipped ssl verification, possible data spoofing though
      raw = RestClient::Request.execute(url: url, method: :get, verify_ssl: false)

      html = Nokogiri::HTML(raw.squish)

      # iterate over pages for that resource
      # need to find a way to explicate pagination movement.
      # may or may not need selenium, different url possibilities, form submissions, etc.
      # for now just look at immediate url for the scrape resource
      (0..0).each do |_n| # placeholder page traversal

        # eventually should extract html and send it off for parsing in another worker while continuing with pagination

        count += scrape_page(html, url, resource)
      end # end page iteration

    end # end resource_url iteration
    logger.info "Nested scraper saved #{count} new valid models for resource #{resource.id} with #{resource.resource_urls.count} urls"
  end # end perform

  def scrape_page(html, url, resource)
    count = 0
    top_selectors = Selector.where(scrape_resource_id: resource.id, top_level: true)
    logger.error "Scrape Resource #{resource.id} has no top_level Selectors (url: #{url})" if top_selectors.count == 0
    top_selectors.each do |ts|
      # an array of all the top-level items for a given tag. these are nokogiri nodes
      html_items = html.css(ts.selector)

      html_items.each do |html_item| # iterates over Nokogiri nodeset for given css selector

        # creates a model with scrape resource info set
        new_model = ts.model.new(scrape_resource_id: resource.id,
                                 institution_id: resource.institution_id,
                                 event_url: url,
                                 public: true)

        # traverse all children for a given selector
        logger.error "top selector #{ts.id} for resource #{resource.id} has no children" if ts.children.count == 0
        ts.children.each do |cs|
          # logger.info "child selector: #{cs.selector}"

          # assumes there is only one element - could iterate instead but what case is that?
          content_item = html_item.css(cs.selector).first

          if !content_item.blank?
            content = content_item.text.squish
            content = next_non_blank(content_item).text.squish if content.blank?
            # logger.info "CONTENT: #{content}"
            new_model.assign_attributes(cs.column_name => content)
          else
            logger.warn "NO CONTENT FOUND for top selector: #{ts.selector} and child selector: #{cs.selector}"
          end
        end # end top selector children iteration

        # saves new model and increments count if it was inputted
        count += 1 if validate_and_save(new_model)

      end # end items iteration

    end # end selector iteration
    count
  end

  def validate_and_save(new_model)
    # will need to check for partial matches that could indicate a change in the displayed content
    # may also need to delete events that are no longer in the feed if they are determined to have been cancelled

    # this structure will collect the attributes to check if the model currently exists in the databse or not
    attrs = {}

    # validate new model using built-in model validations
    valid = new_model.valid?
    unless valid
      logger.warn "INITIALLY invalid model after scraping: #{new_model.errors.messages}"

      # attempt to fix certain validation errors
      if new_model.class == SimpleEvent
        logger.info 'repairing simple event'
        repair_simple_event(new_model)

        attrs[:title] = new_model.title
        attrs[:institution_id] = new_model.institution_id
        attrs[:start_date] = new_model.start_date
      elsif new_model.class == AthleticEvent
        logger.info 'repairing athletic event (or will be...)'
      else
        # handle other types as they come up building the scraping
      end
    end

    # clear errors to retry validations after attempted fixes
    new_model.errors.clear
    valid = new_model.valid?
    # perform save
    if valid
      # performs non-duplicative save
      result = new_model.non_duplicative_save
      if result
        logger.info "Saved validated model of type '#{new_model.class}' with id: #{new_model.id}\n"
      else
        logger.info "Validated model of type '#{new_model.class}' already existed and was not saved"
      end
      return result
    else
      logger.warn "failed to save model with errors #{new_model.errors.messages} and data: #{new_model.inspect}\n"
    end
    false
  end

  def repair_simple_event(event)
    err = event.errors.messages
    if err.keys.include? :end_date
      logger.warn 'setting length of event without end date arbitarily to 1 hour'
      # set a default event length of 1 hour
      event.end_date = event.start_date + 1.hours if event.start_date
    else
      # handle other possible errors
    end
  end

  def next_non_blank(elem)
    elem = elem.next while elem.text.blank?
    elem
  end
end
