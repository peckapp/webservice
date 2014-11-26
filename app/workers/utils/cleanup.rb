module Utils
  # performs cleanup of the database to eliminate wasted space on old unneeded data
  class Cleanup
    include Sidekiq::Worker
    sidekiq_options unique: true

    include Sidetiq::Schedulable
    recurrence { daily(2) }

    def perform
      clear_scraped_menu_items
      clear_old_simple_events
      clear_old_athletic_events
    end

    def clear_old_menu_items
      logger.info 'deleting menu items older than 5 days for all institutions'
      MenuItem.where(date_available: 1000.days.ago..5.days.ago).each do |mi|
        mi.destroy
      end
    end

    def clear_old_simple_events
    end

    def clear_old_athletic_events
    end
  end
end
