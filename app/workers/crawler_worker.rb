# this class handles the main crawl loop and dispatches other workers to parse individual pages

class CrawlerWorker

  include Sidekiq::Worker
  include Sidetiq::Schedulable

  QUEUE_NAME = "general_crawl"

  recurrence { daily }

  def perform

  end

  private

    def crawl_loop(root_url, timeout=8, page_quantity=15000, bf_bits=15)
      # mechanize agent to perform the link traversals
      agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
      agent.read_timeout = timeout
      agent.open_timeout = timeout

      # queue to store the links for this crawl
      crawl_queue = Array.new

      # bloom filter to prevent repeated page crawls
      k = (0.7 * bf_bits).ceil
      bf = BloomFilter::Native.new(size: page_quantity, hashes: k, seed: 1)

      # inserts a page into the queue as a seed
      root_page = agent.get(root_url)
      crawl_queue.insert(0,root_page)

    end

end
