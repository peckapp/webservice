module Api
  module V1
    class ExploreController < ApplicationController #Api::BaseController

      respond_to :json

      def index

        #### Simple Events ####
        @event_positions = {}

        event_position = 1

        @simple_events = specific_index(SimpleEvent, params).sorted

        @explore_events = []

        for event in @simple_events
          if !event.start_date.past?
            # if event.image_url = "null"
            #   event.image_url = "/images/event.png"
            # end
            @event_positions[event.id] = event_position
            @explore_events << event
            event_position += 1
          end
          break if @explore_events.count == 5
        end

        # initialize hash mapping events to arrays of likers
        @likes_for_explore_events = {}

        @explore_events.each do |event|
          likers = []
          event.likers(User).each do |user|
            likers << user.id
          end

          @likes_for_explore_events[event] = likers
        end

        #### Announcements ####
        @announcement_positions = {}

        announcement_position = 1

        # announcements sorted on creation date
        @announcements = specific_index(Announcement, params).sorted

        @explore_announcements = []

        for announcement in @announcements
          @announcement_positions[announcement.id] = announcement_position
          @explore_announcements << announcement
          announcement_position += 1
          break if @explore_announcements.count == 5
        end

        @likes_for_explore_announcements = {}

        # for each announcement
        @explore_announcements.each do |announcement|
          likers = []

          # for each liker in the array of announcement likers, add the user's id
          announcement.likers(User).each do |user|
            likers << user.id
          end

          @likes_for_explore_announcements[announcement] = likers
        end
      end
    end
  end
end
