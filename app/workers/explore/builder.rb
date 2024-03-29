# nests all explore workers within their own module
module Explore
  # master worker that sends off analysis workers for each event
  class Builder
    include Sidekiq::Worker

    include Sidetiq::Schedulable
    recurrence { hourly }

    # ideally would add an optional method parameter to specify an institution_id, but not necessary for now
    def perform
      @cache_client = PeckDalli.client

      Institution.all.pluck(:id).each do |inst_id|
        logger.info "starting explore builder for institution #{inst_id}"

        @cache_client.set("campus_athletic_explore_#{inst_id}", analyze_athletic_events(inst_id))
        @cache_client.set("campus_simple_explore_#{inst_id}", analyze_simple_events(inst_id))
        @cache_client.set("campus_announcement_explore_#{inst_id}", analyze_announcements(inst_id))
      end
    end

    protected

    ### TODO: These currently explicitly create instances of the analyzer class
    ###       should utilize the concurrent nature of sidekiq more fully by using analyzer asynchronously

    def analyze_simple_events(institution_id)
      analyzer = Explore::Analyzer.new
      analysis_group = SimpleEvent.where(start_date: Time.now..1.month.from_now)

      event_scores = analysis_group.reduce([]) do |acc, e|

        acc << [e.id, analyzer.perform(e.id, institution_id, SimpleEvent)]

      end
      logger.info "Builder analyzed simple events. #{event_scores.count} scores calculated for institution #{institution_id}"
      Hash[event_scores]
    end

    def analyze_announcements(institution_id)
      analyzer = Explore::Analyzer.new
      analysis_group = Announcement.where(created_at: 1.month.ago..Time.now)

      announcement_scores = analysis_group.reduce([]) do |acc, e|

        acc << [e.id, analyzer.perform(e.id, institution_id, Announcement)]

      end
      logger.info "Builder analyzed announcements with #{announcement_scores.count} scores calculated for institution #{institution_id}"
      Hash[announcement_scores]
    end

    def analyze_athletic_events(institution_id)
      analyzer = Explore::Analyzer.new
      analysis_group = AthleticEvent.where(start_date: Time.now..1.month.from_now)

      athletic_scores = analysis_group.reduce([]) do |acc, e|

        acc << [e.id, analyzer.perform(e.id, institution_id, AthleticEvent)]

      end
      logger.info "Builder analyzed athletic events with #{athletic_scores.count} scores calculated for institution #{institution_id}"
      Hash[athletic_scores]
    end
  end
end
