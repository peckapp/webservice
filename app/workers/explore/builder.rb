# nests all explore workers within their own module
module Explore
  # master worker that sends off analysis workers for each event
  class Builder
    include Sidekiq::Worker

    include Sidetiq::Schedulable

    require 'dalli'
    # to be turned on once development of this functionality is complete
    # recurrence { hourly }

    def perform(institution_id)
      options = { namespace: 'peck', compress: true }
      @cache_client = Dalli::Client.new('localhost:11211', options)

      @cache_client.set('campus_explore', analyze_simple_events(institution_id))
      # analyze_athletic_events(institution_id)
      # analyze_announcements(institution_id)
    end

    protected

    # should add something to only get a certain range of dates

    def analyze_simple_events(institution_id)
      analyzer = Explore::EventAnalyzer.new
      analysis_group_datetime = SimpleEvent.where(start_date: Time.now..1.month.from_now).pluck(:id)
      analysis_group_epoch = SimpleEvent.where(start_date: Time.now.to_i..1.month.from_now.to_i).pluck(:id)
      analysis_group_ids = (analysis_group_datetime + analysis_group_epoch).uniq

      logger.info "------> #{Time.now.to_i} -------- #{1.month.from_now.to_i} <-------"

      analysis_group = SimpleEvent.where(id: analysis_group_ids)

      event_scores = analysis_group.reduce([]) do |acc, e|

        acc << [e.id, analyzer.perform(e.id, institution_id, 'SimpleEvent')]

      end

      Hash[event_scores]
    end

    def analyze_athletic_events(institution_id)
      athletic_event_ids = AthleticEvent.where(institution_id: institution_id).pluck(:id)
      athletic_event_ids.each do |id|
        # uses general event analyzer that requires a model name
        Explore::EventAnalyzer.perform_async(id, 'AthleticEvent')
      end
    end

    def analyze_announcements(institution_id)
      announcment_ids = Announcement.where(institution_id: institution_id).pluck(:id)
      announcment_ids.each do |id|
        Explore::AnnouncementAnalyzer.perform_async(id)
      end
    end
  end
end
