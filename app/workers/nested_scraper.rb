# a worker using database information to scrape structured data off of websites
# correctly handles rss feeds in any format, but untested elsewhere
# relies on a nested structure of the html content
class NestedScraper
  include Sidekiq::Worker
  sidekiq_options queue: :scraping, retry: 5

  # recurrence { daily }

  # leave out of new_relic apdex score
  # newrelic_ignore_apdex

  PAGE_LIMIT = 30

  def perform(resource_id)
    if resource_id < 1
      logger.error "NestedScraper passed #{resource_id} requires a valid id as a parameter"
      return
    end
    resource = ScrapeResource.find(resource_id)

    logger.info "Scraping nested resource #{resource.id} with #{resource.resource_urls.count} urls and info: #{resource.info}"

    count = 0
    resource.resource_urls.each do |r_url|
      # no dangerous security concern present here with skipped ssl verification, possible data spoofing though
      raw = RestClient::Request.execute(url: r_url.url, method: :get, verify_ssl: false)

      html = Nokogiri::HTML(raw.squish)

      # iterate over pages for that resource
      # need to find a way to explicate pagination movement.
      # may or may not need selenium, different url possibilities, form submissions, etc.
      # for now just look at immediate url for the scrape resource
      (0..0).each do |_n| # placeholder page traversal

        # eventually should extract html and send it off for parsing in another worker while continuing with pagination

        count += scrape_page(html, r_url, resource) || 0
      end # end page iteration
    end # end resource_url iteration
    logger.info "Nested scraper saved #{count} new valid models for resource #{resource.id} with #{resource.resource_urls.count} urls"
  end # end perform

  def scrape_page(html, r_url, resource)
    count = 0
    top_selectors = Selector.where(scrape_resource_id: resource.id, top_level: true)
    logger.error "Scrape Resource #{resource.id} has no top_level Selectors (url: #{r_url.url})" if top_selectors.count == 0
    top_selectors.each do |ts|
      # an array of all the top-level items for a given tag. these are nokogiri nodes
      html_items = html.css(ts.selector)

      html_items.each do |html_item| # iterates over Nokogiri nodeset for given css selector

        # creates a model with scrape resource info set
        new_model = ts.model.new(scrape_resource_id: resource.id,
                                 institution_id: resource.institution_id,
                                 url: r_url.url,
                                 public: true)

        # traverse all children for a given selector
        logger.error "top selector #{ts.id} for resource #{resource.id} has no children" if ts.children.count == 0
        ts.children.each do |cs|
          # logger.info "child selector: #{cs.selector}"

          # assumes there is only one element - could iterate instead but what case is that?
          content_item = html_item.css(cs.selector).first

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

        # saves new model and increments count if it was inputted
        count += 1 if validate_and_save(new_model)
      end # end items iteration
    end # end selector iteration
    count
  end

  def validate_and_save(new_model)
    # will need to check for partial matches that could indicate a change in the displayed content
    # may also need to delete events that are no longer in the feed if they are determined to have been cancelled

    # validate new model using built-in model validations
    repair_model(new_model) unless new_model.valid?

    # clear errors to retry validations after attempted fixes
    new_model.errors.clear
    # perform save
    if new_model.valid?
      # performs non-duplicative save
      result = new_model.non_duplicative_save
      if result
        logger.info "Saved validated model of type '#{new_model.class}' with id: #{new_model.id}\n"
      else
        logger.info "Validated model of type '#{new_model.class}' already existed and was not saved"
      end
      return result
    else
      # logger.info new_model.start_time.class
      logger.warn "failed to save model with errors #{new_model.errors.messages} and data: #{new_model.inspect}\n"
    end
    false
  end

  # hands model to its specific repair method
  def repair_model(model)
    logger.warn "INITIALLY invalid model #{model.class} after scraping: #{model.errors.messages}"

    # attempt to fix certain validation errors
    if model.class == SimpleEvent
      repair_simple_event(model)
    elsif model.class ==  AthleticEvent
      repair_athletic_event(model)
    elsif model.class ==  AthleticTeam
      repair_athletic_team(model)
    else
      logger.info "Attempted to repair model of class #{model.class} without a handler"
      # handle other types as they come up building the scraping
    end
  end

  def repair_simple_event(event)
    # logger.info 'repairing simple event'
    err = event.errors.messages
    if err.keys.include? :end_date
      logger.warn 'setting length of event without end date arbitarily to 1 hour'
      # set a default event length of 1 hour
      event.end_date = event.start_date + 1.hours if event.start_date
    else
      # handle other possible errors
    end
  end

  def repair_athletic_event(event)
    # logger.info 'repairing athletic event'
    err = event.errors.messages
    err.keys.each do |key|
      case key
      when :location
        # logger.warn "Arbitrarily assigning 'Williams College' as the location for athletic event. TODO: follow links for this info"
        event.location = 'Williams College'
      else
        logger.error "repair_athletic_event failed to handle key: #{key}"
      end
    end
  end

  def repair_athletic_team(team)
    # logger.info 'repairing athletic team'
    err = team.errors.messages
    err.keys.each do |key|
      case key
      when :sport_name
        # could use some work, may not apply to every case
        team.sport_name = sport
      when :gender
        gender = team.simple_name.match(/(M|m)en|(W|w)omen/).to_s
        team.gender = gender
      else
        logger.error "repair_athletic_team failed to handle key: #{key}"
      end
    end
    logger.info
  end

  def next_non_blank(elem)
    elem = elem.next while elem.text.blank?
    elem
  end
end
