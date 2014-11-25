module Utils
  # performs cleanup of the database to eliminate wasted space on old unneeded data
  class Cleanup
    include Sidekiq::Worker
    sidekiq_options unique: true

    recurrence { weekly }

    def perform
      clear_scraped_menu_items
      clear_old_simple_events
      clear_old_athletic_events
    end

    def clear_old_menu_items
    end

    def clear_old_simple_events
    end

    def clear_old_athletic_events
    end
  end
end
