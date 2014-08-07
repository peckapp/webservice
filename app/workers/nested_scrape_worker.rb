# a worker using database information to scrape structured data off of websites
# correctly handles rss feeds in any format, but untested elsewhere
# relies on a nested structure of the html content
class NestedScrapeWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  PAGE_LIMIT = 30

  def perform(*attrs)
    attrs = attrs.extract_options!
    logger.info "specified attrs for perform: #{attrs}"
    resources = ScrapeResource.where(attrs)

    # iterate over all resources
    resources.each do |resource|

      logger.info "scraping resource #{resource.id} with info: #{resource.info}"

      # no dangerous security concern present here, possible data spoofing though
      raw = RestClient::Request.execute(url: resource.url, method: :get, verify_ssl: false)

      html = Nokogiri::HTML(raw.squish)

      # iterate over pages for that resource
      # need to find a way to explicate pagination movement.
      # may or may not need selenium, different url possibilities, form submissions, etc.
      # for now just look at immediate url for the scrape resource
      (0..0).each do |_n| # placeholder page traversal

        # eventually will extract html and send it off for parsing while continuing with pagination

        top_selectors = Selector.where(id: resource.id, top_level: true)
        top_selectors.each do |ts|

          logger.info "Iterating over top level selector ts: #{ts.selector}"

          # an array of all the top-level items for a given tag. these are nokogiri nodes
          html_items = html.css(ts.selector)

          html_items.each do |html_item| # iterates over Nokogiri nodeset for given css selector

            # creates a model with scrape resource info set
            new_model = ts.model.new(scrape_resource_id: resource.id,
                                     institution_id: resource.institution_id)

            # traverse all children for a given selector
            ts.children.each do |cs|

              logger.info "child selector: #{cs.selector}"

              # assumes there is only one element - could iterate instead but what case is that?
              content_item = html_item.css(cs.selector).first

              if !content_item.blank?
                content = content_item.text.squish
                if content.blank?
                  content = next_non_blank(content_item).text.squish
                end
                # logger.info "CONTENT: #{content}"
                new_model.assign_attributes(cs.column_name => content)
              else
                logger.warn "NO CONTENT FOUND for top selector: #{ts.selector} and child selector: #{cs.selector}"
              end
            end # end top selector children iteration

            validate_and_save(new_model)

          end # end items iteration

        end # end selector iteration
      end # end page iteration
    end # end resources do
  end # end perform

  def validate_and_save(new_model)
    # will need to check for partial matches that could indicate a change in the displayed content
    # may also need to delete events that are no longer in the feed if they are determined to have been cancelled

    # this structure will collect the attributes to check if the model currently exists in the databse or not
    attrs = {}

    # validate new model using built-in model validations
    valid = new_model.valid?
    unless valid
      logger.warn "model is initially invalid after scraping due to: #{new_model.errors.messages}"

      # attempt to fix certain validation errors
      if new_model.class == SimpleEvent
        logger.info 'repairing simple event'
        repair_simple_event(new_model)

        attrs[:title] = new_model.title
        attrs[:institution_id] = new_model.institution_id
        attrs[:start_date] = new_model.start_date
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
    else
      logger.warn "did not save invalid model with errors #{new_model.errors.messages} and model: #{new_model.inspect}\n"
    end
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
