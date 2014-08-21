# nests all explore workers within their own module
module Explore
  # master worker that sends off analysis workers for each event
  class Builder
    include Sidekiq::Worker

    include Sidetiq::Schedulable

    require 'dalli'
    # to be turned on once development of this functionality is complete
    # recurrence { hourly }

    recurrence { hourly }

    def perform(institution_id)
      @cache_client = PeckDalli.client

      @cache_client.set("campus_simple_explore_#{institution_id}", analyze_simple_events(institution_id))
      @cache_client.set("campus_athletic_explore_#{institution_id}", analyze_athletic_events(institution_id))
      @cache_client.set("campus_announcement_explore_#{institution_id}", analyze_announcements(institution_id))
    end

    protected

    # should add something to only get a certain range of dates

    def analyze_simple_events(institution_id)
      analyzer = Explore::Analyzer.new
      analysis_group = SimpleEvent.where(start_date: Time.now..1.month.from_now)

      event_scores = analysis_group.reduce([]) do |acc, e|

        acc << [e.id, analyzer.perform(e.id, institution_id, SimpleEvent)]

      end

      Hash[event_scores]
    end

    def analyze_announcements(institution_id)
      analyzer = Explore::Analyzer.new
      analysis_group = Announcement.where(created_at: 1.month.ago..Time.now)

      announcement_scores = analysis_group.reduce([]) do |acc, e|

        acc << [e.id, analyzer.perform(e.id, institution_id, Announcement)]

      end

      Hash[announcement_scores]
    end

    def analyze_athletic_events(institution_id)
      analyzer = Explore::Analyzer.new
      analysis_group = AthleticEvent.where(created_at: Time.now..1.month.from_now)

      athletic_scores = analysis_group.reduce([]) do |acc, e|

        acc << [e.id, analyzer.perform(e.id, institution_id, AthleticEvent)]

      end

      Hash[athletic_scores]
    end
  end
end
