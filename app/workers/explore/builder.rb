# nests all explore workers within their own module
module Explore
  # master worker that sends off analysis workers for each event
  class Builder
    include Sidekiq::Worker

    def perform(institution_id)
      analyze_simple_events(institution_id)
      analyze_athletic_events(institution_id)
      analyze_announcements(institution_id)
    end

    protected

    def analyze_simple_events(institution_id)
      simple_event_ids = SimpleEvent.where(institution_id: institution_id).pluck(:id)
      simple_event_ids.each do |id|
        Explore::SimpleEventAnalyzer.perform_async(id, 'SimpleEvent')
      end
    end

    def analyze_athletic_events(institution_id)
      athletic_event_ids = AthleticEvent.where(institution_id: institution_id).pluck(:id)
      athletic_event_ids.each do |id|
        Explore::AthleticEventAnalyzer.perform_async(id, 'AthleticEvent')
      end
    end

    def analyze_announcements(institution_id)
      announcment_ids = Announcement.where(institution_id: institution_id).pluck(:id)
      announcment_ids.each do |id|
        Explore::AnnouncementAnalyzer.perform_async(id, 'Announcement')
      end
    end
  end
end
