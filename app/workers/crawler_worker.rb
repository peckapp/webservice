# this class handles the main crawl loop and dispatches other workers to parse individual pages

class CrawlerWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  # bloom filter as a persistent class variable
  # use is for efficiency, not accuracy, so occasional race conditions won't matter
  @@bf = nil

  def perform(*_attrs)
    CrawlSeed.all.each do |seed|
      crawl_loop(seed.url, seed.institution_id) if seed.active
    end
  end

  private

  def crawl_loop(seed_url, inst_id, timeout = 8, page_quantity = 15_000, bf_bits = 15)
    # mechanize agent to perform the link traversals, no ssl verification for crawling process to eliminate certificate errors
    agent = Mechanize.new { |a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE }
    agent.read_timeout = timeout
    agent.open_timeout = timeout

    # queue to store the links for this crawl
    crawl_queue = []

    # bloom filter to prevent repeated page crawls, instantiated only if currently nil
    k = (0.7 * bf_bits).ceil
    @@bf = BloomFilter::Native.new(size: page_quantity, hashes: k, seed: 1) if @@bf.blank?

    seed_host = URI(seed_url).host.to_s # host of the seed url used for domain matching

    # inserts a url into the queue as a seed
    crawl_queue.insert(0, seed_url)

    until @crawl_queue.empty?
      url = @crawl_queue.pop

      page = agent.get(url)

      next unless page.is_a? Mechanize::Page

      page.links.each do |l|
        next if @@bf.include?(l.href.to_s) # link has already been traversed
        @@bf.insert(l.href.to_s) # otherwise insert it

        # necessary conditions for the link to be followed
        next unless acceptable_link_format?(l) && within_domain?(l.uri, seed_host)

        begin
          # add the link string to the front of the queue
          crawl_queue.insert(0, l.to_s)
        rescue Timeout::Error
          # resuest timed out, could repeat it or add to queue, but for now just continue on
        rescue Mechanize::ResponseCodeError => exception
          # handle various response code errors
          if exception.response_code == '403'
            new_page = exception.page
          else
            raise # Some other error, re-raise for now
          end
        end

        ### Sends off the task asynchronously to another worker ###
        PageCrawlAnalyzer.perform_async(new_page.uri.to_s, inst_id)

        # sleep time to keep the crawl interval unpredictable and prevent lockout from certain sites
        sleep(1 + rand)

      end # end inner link traversal

    end # end outer while loop
  end # end crawl_loop method

  ### utility methods for the crawler

  def acceptable_link_format?(link)
    begin
      return false if link.to_s.match(/#/) || link.uri.to_s.empty? # handles anchor links within the page
      scheme = link.uri.scheme
      return false if (!scheme.nil?) && (scheme != 'http') && (scheme != 'https') # eliminates non http,https, or relative links
      # prevents download of media files, should be a better way to do this than by explicit checks for each type
      return false if link.to_s.match(/.pdf|.jgp|.jgp2|.png|.gif/)
    rescue
      return false
    end
    true
  end

  def within_domain?(link, root)
    if link.relative?
      true # handles relative links within the site
    else
      # matches the current links host with the top-level domain string of the seed URI
      link.host.match(root.to_s) ? true : false
    end
  end
end
