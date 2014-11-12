# Built off the foundation of the NestedScraper which was becoming bloated

# still runs on the assumption that each model is contained within a single top selector

# a worker using database information to scrape structured data off of websites
# correctly handles rss feeds in any format, but untested elsewhere
# relies on a nested structure of the html content
class NestedTraverseScraper
  # handles saving and updating scrapes models
  include IdempotentUpdates

  include Sidekiq::Worker
  sidekiq_options queue: :scraping, retry: 5

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
