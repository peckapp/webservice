module Api
  module V1
    # this class handles the output of the explore feed, speficif to the user requesting it
    class ExploreController < ApplicationController
      respond_to :json

      NUMBER_OF_EVENTS = 200

      # # for now, just returns the 5 most recent events
      # def index
      #
      #   #### Announcements ####
      #   @announcement_positions = {}
      #
      #   announcement_position = 1
      #
      #   # announcements sorted on creation date
      #   @announcements = specific_index(Announcement, params).sorted
      #
      #   @explore_announcements = []
      #
      #   @announcements.each do |announcement|
      #     @announcement_positions[announcement.id] = announcement_position
      #     @explore_announcements << announcement
      #     announcement_position += 1
      #     break if @explore_announcements.count == 5
      #   end
      #
      #   @likes_for_explore_announcements = {}
      #
      #   # for each announcement
      #   @explore_announcements.each do |announcement|
      #     likers = []
      #
      #     # for each liker in the array of announcement likers, add the user's id
      #     announcement.likers(User).each do |user|
      #       likers << user.id
      #     end
      #
      #     @likes_for_explore_announcements[announcement] = likers
      #   end
      # end

      def index

        options = { :namespace => "peck", :compress => true }
        dc = Dalli::Client.new('localhost:11211', options)
        scores = dc.get('campus_explore')

        logger.info("-----> #{scores} <-----")

        personalizer = Personalizer.new

        personal_scores = personalizer.perform(scores, params[:authentication][:user_id], params[:authentication][:institution_id])

        logger.info("-----> #{personal_scores} <-----")

        explore_ids = []
        @explore_scores = {}
        (0...NUMBER_OF_EVENTS).each do |n|
          explore_ids << personal_scores[n][0]
          @explore_scores[personal_scores[n][0]] = personal_scores[n][1]
        end

        @explore_events = SimpleEvent.where(id: explore_ids)

        # initialize hash mapping events to arrays of likers
        @likes_for_explore_events = {}

        all_likes = Like.where(likeable_type: "SimpleEvent", likeable_id: explore_ids).pluck(:likeable_id, :liker_id)


        all_likes.each do |like|

          if @likes_for_explore_events[like[0]]
            @likes_for_explore_events[like[0]] << like[1]
          else
            @likes_for_explore_events[like[0]] = [like[1]]
          end
        end
      end
    end
  end
end
