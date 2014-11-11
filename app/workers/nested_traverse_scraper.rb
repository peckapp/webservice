# Built off the foundation of the NestedScraper which was becoming bloated

# still runs on the assumption that each model is contained within a single top selector

# a worker using database information to scrape structured data off of websites
# correctly handles rss feeds in any format, but untested elsewhere
# relies on a nested structure of the html content
class NestedTraverseScraper
  include Sidekiq::Worker
  sidekiq_options queue: :scraping, retry: 5

  STANDARD_COLUMNS = %w(id created_at updated_at image_file_name image_content_type image_file_size image_updated_at)

  # leave out of new_relic apdex score
  # newrelic_ignore_apdex

  PAGE_LIMIT = 30

  def perform(resource_id)
    logger.error "NestedScraper was passed #{resource_id} and requires a valid id as a parameter" if resource_id < 1
    return if resource_id < 1

    resource = ScrapeResource.find(resource_id)
    logger.info "Scraping nested resource #{resource.id}: '#{resource.info}' with #{resource.resource_urls.count} urls"

    count = resource.resource_urls.reduce(0) do |acc, r_url|
      be_nice # wait time between page loads

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
    count = Selector.where(scrape_resource_id: resource.id, top_level: true).reduce(0) do |acc, ts|
      # an array of all the top-level items for a given tag. these are nokogiri nodes
      blocks = html.css(ts.selector)

      blocks.each do |block| # iterates over Nokogiri nodeset for given css selector
        # logger.info "scraping index page with block: #{block}"

        # creates a model with default scrape resource info set
        # logger.info 'CREATING NEW TEMPLATE MODEL'
        new_model = ts.model.new(scrape_resource_id: resource.id,
                                 url: r_url.url,
                                 institution_id: resource.institution_id,
                                 public: true)

        iterate_children(ts, block, new_model)

        # saves new model and increments count if it was inputted
        acc + 1 if validate_and_save(new_model)
      end # end items iteration
    end # end selector iteration
    count
  end

  # builds up the data for the model defined by the structure of the top selector and its child selectors
  # traverse all children for a given top selector
  def iterate_children(ts, block, new_model)
    ts.children.each do |cs|
      # assumes there is only one element - could iterate instead but what case would that be?
      element = block.css(cs.selector).first

      handle_element(cs, element, new_model)
    end # end top selector children iteration
  end # end iterate_children method

  ###############################################
  ###  Scraping the detail page for an event  ###
  ###############################################

  def detail_page_scrape(cs, url, new_model)
    be_nice # wait time between page loads

    raw = RestClient::Request.execute(url: url, method: :get, verify_ssl: false)

    html = Nokogiri::HTML(raw.squish)

    # this page is itself a child, so its children are grandchildren
    # for each grandchild, update the model with the value
    cs.children.each do |gcs|
      element = html.css(gcs.selector).first

      handle_element(gcs, element, new_model)
    end
  end # end detail_page_scrape method

  ##############################################
  ###  Handling new data for partial models  ###
  ##############################################

  def handle_element(cs, element, new_model)
    case cs.content_type
    when 'content'
      handle_content_element(cs, element, new_model)
    when 'foreign_key'
      handle_foreign_key_element(cs, element, new_model)
    when 'link'
      # handles parsing issues with malformed HTML where content isn't captured by the selector (williams rss links)
      url = element.text.blank? ? next_non_blank(element).text.squish : element.text.squish
      # needs to save the url in the model in order to display the detail page rather than the index
      new_model.assign_attributes(cs.column_name => url)
      detail_page_scrape(cs, url, new_model)
    else
      logger.error "UNKNOWN CONTENT TYPE for child selector #{cs.id}: #{cs.selector}"
    end # end content_type case statement
  end

  # parses a simple content element where the text ust has to be assigned to the model attribute
  def handle_content_element(cs, element, new_model)
    if element.blank?
      logger.warn "MISSING ELEMENT for child selector #{cs.id} (#{cs.info}): #{cs.selector}\nat url: #{new_model.url}"
      return
    end

    content = nil
    case cs.data_resource.data_type
    when 'text', 'url', 'date'
      # assumes content is the text at this element
      content = element.text.squish
      # handles parsing issues with malformed HTML where content isn't captured by the selector (williams rss links)
      # logger.warn 'looking for next non blank' if content.blank?
      content = next_non_blank(element).text.squish if content.blank?
    when 'image'
      # logger.info "saving image with url: #{element['url']}"
      content = URI.parse(element['url'])
    else
    end

    # assign the text-based content to the proper column of the model
    new_model.assign_attributes(cs.column_name => content)
  end

  # parses an element corresponding to a foreign key by finding the matching model and assigning the ID
  def handle_foreign_key_element(cs, element, new_model)
    # finds the current model matching the single found parameter or creates a new one
    foreign_resource = cs.foreign_data_resource

    if element.nil?
      logger.info 'NIL ELEMENT for foreign key'
      return
    end

    content_model = foreign_resource.minimal_current_or_new(element.text)
    content_model[:institution_id] = cs.scrape_resource.institution_id

    # models for foreign key content must be saved just as any other model, if they existed previously nothing happens
    validate_and_save(content_model)
    # logger.info "found content_model for selector cs.id: #{content_model.inspect}"
    new_model.assign_attributes(cs.column_name => content_model.id)
    # category must always be assigned to indicate which foreign resource type is related
    new_model.assign_attributes(category: foreign_resource.resource_type.resource_name)
  end

  #############################################
  ###  Final validations to scraped models  ###
  #############################################

  def validate_and_save(new_model)
    # will need to check for partial matches that could indicate a change in the displayed content
    # may also need to delete events that are no longer in the feed if they are determined to have been cancelled

    # if model is invalid using built-in validations, attempt to repair it
    Reparator.repair_model(new_model, logger) unless new_model.valid?

    # clear errors to retry validations after attempted fixes
    new_model.errors.clear
    # perform save
    if new_model.valid?
      idempotent_save_or_update(new_model)
    else
      # logger.info new_model.start_date.class
      logger.warn "failed to save model with errors #{new_model.errors.messages}\ntitle: #{new_model.title}\nurl: #{new_model.url}"
    end
    false
  end

  def idempotent_save_or_update(new_model)
    crucial_params = model_crucial_params(new_model)
    match_params = model_match_params(new_model)

    if exact_match?(new_model, crucial_params, match_params)
      return
    end

    match = closest_match(new_model, crucial_params, match_params)
    # logger.info "closest_match: #{match.inspect}"
    if match # either a complete match was found, or no match was found at all
      return update_matching_model(match, new_model)
    end

    # default relying on solely non-duplicative save
    default_save(new_model)
  end

  # updates the found match with the parameters in the new model that are more current
  def update_matching_model(match, new_model)
    changed = 0
    new_model.class.column_names.each do |k|
      next if (new_model[k] == match[k]) || STANDARD_COLUMNS.include?(k) # nothing to do or column should remain the same
      changed += 1
      # logger.info "XXX #{k} XXX old: #{match[k]} => new: #{new_model[k]}" if new_model[k] != match[k]
      match.update_attributes({ k => new_model[k] })
    end
    logger.info "Updated matching model of type '#{match.class}' of id: #{match.id} with #{changed} modified fields"
    return match.save
  end

  # executes the default saving behavior with only simple exect duplicate protection
  def default_save(new_model)
    if new_model.non_duplicative_save
      logger.info "Saved validated model of type '#{new_model.class}' with id: #{new_model.id}\n"
      return true
    else
      logger.info "Validated model of type '#{new_model.class}' already existed and was not saved"
    end
  end

  #########################################
  ###  Finding matches in the Database  ###
  #########################################

  # determines whether or not an exact match exists for the found parameters
  def exact_match?(new_model, crucial_params, match_params)
    all_params = crucial_params.merge(match_params)
    # logger.info "all_params: #{all_params}"
    matches = new_model.class.where(all_params)
    return false unless matches.any?
    if matches.count > 1
      logger.warn 'Multiple exact matches found for the scraped new model. Something is wrong'
      logger.info "#{matches.count} matches found for #{new_model.class} with params #{all_params}"
    end
    if new_model.class == SimpleEvent
      logger.info "exact match found for params #{all_params.keys}, moving to next item"
    end
    true
  end

  # uses match parameters until a singluar match is found
  def closest_match(new_model, crucial_params, match_params)
    best_matches = []
    # for an increasing number of parameters, look for matches with all combinations of that number of match params
    # looks for the match fitting the highest number of parameters and chooses that one
    # TODO: can be optimized since certain possibilities can be nipped out of future iterations if their descendants did not have matches
    1.upto(match_params.count-1) do |count|
      match_found = false
      CombinatorialIterator.new(count, match_params).mapCombinations do |params|
        cur_params = crucial_params.merge(params)
        matches = new_model.class.where(cur_params)
        # logger.info "found #{matches.count} matches for cur_params: #{cur_params.keys}"
        if matches.any?
          match_found = true
          # logger.info "new_model: #{new_model.inspect}\nmatch: #{matches.first.inspect}"
          best_matches = matches
        end
      end
      break unless match_found # stop the iteration is no matches were found for this humber of parameters
    end
    return best_matches.first
  end

  # return the params defined in the models that indicate which fields are crucial to match exactly, and which are flexible
  def model_crucial_params(new_model)
    logger.error "CRUCIAL_ATTRS undefined for model #{new_model.class}" unless defined? new_model.class::CRUCIAL_ATTRS
    Hash[new_model.class::CRUCIAL_ATTRS.map { |a| [a, new_model[a]] }]
  end
  def model_match_params(new_model)
    logger.error "MATCH_ATTRS undefined for model #{new_model.class}" unless defined? new_model.class::MATCH_ATTRS
    Hash[new_model.class::MATCH_ATTRS.map { |a| [a, new_model[a]] }]
  end

  #################################
  ###  Helpful utility methods  ###
  #################################

  def next_non_blank(elem)
    elem = elem.next while elem.text.blank?
    elem
  end

  def be_nice
    sleep 1.0 + rand
  end
end
