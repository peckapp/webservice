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

      # index page shows the personalized campus-specific explore feed
      def index
        dc = PeckDalli.client
        scores = dc.get("campus_explore_#{auth_inst_id}")
        if scores.blank?
          # trigger campus explore calculation, or perform manually.
          Explore::Builder.perform_async(auth_inst_id)

          # send back a status code
          response.headers['Retry-After'] = 10 # indicated a retry time of 10 seconds. could make this more dynamic
          render status: :service_unavailable
        end

        # save all events that user is attending to remove it from explore
        user_events = EventAttendee.where(user_id: auth_inst_id, category: "simple").pluck(:event_attended)

        personalizer = Personalizer.new

        personal_scores = personalizer.perform(scores, auth_user_id, auth_inst_id)

        explore_ids = []
        @explore_scores = {}
        (0...NUMBER_OF_EVENTS).each do |n|
          next unless personal_scores[n]
          # make sure user is not attending
          unless user_events.include?(personal_scores[n][0])
            explore_ids << personal_scores[n][0]
            @explore_scores[personal_scores[n][0]] = personal_scores[n][1]
          end
        end

        @explore_events = SimpleEvent.where(id: explore_ids).where.not(user_id: params[:authentication][:user_id])

        # initialize hash mapping events to arrays of likers
        @likes_for_explore_events = {}

        all_likes = Like.where(likeable_type: 'SimpleEvent', likeable_id: explore_ids).pluck(:likeable_id, :liker_id)

        all_likes.each do |like|

          if @likes_for_explore_events[like[0]]
            @likes_for_explore_events[like[0]] << like[1]
          else
            @likes_for_explore_events[like[0]] = [like[1]]
          end
        end
      end
    end

    protected

    def auth_inst_id
      params.require(:authentication).permit(:institution_id)
    end

    def auth_user_id
      params.require(:authentication).permit(:user_id)
    end
  end
end
