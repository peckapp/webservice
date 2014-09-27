module Api
  module V1
    # this class handles the output of the explore feed, specific to the user requesting it
    class ExploreController < ApplicationController
      respond_to :json

      helper_method :auth_inst_id
      helper_method :auth_user_id

      NUMBER_OF_EXPLORE_ITEMS = 200

      # index page shows the personalized user-specific explore feed

      def index
        dc = PeckDalli.client
        simple_scores = dc.get("campus_simple_explore_#{auth_inst_id}")
        announcement_scores = dc.get("campus_announcement_explore_#{auth_inst_id}")
        athletic_scores = dc.get("campus_athletic_explore_#{auth_inst_id}")

        # runs the builder and returns if the cache is empty
        if simple_scores.blank? && announcement_scores.blank? && athletic_scores.blank?
          run_builder

          head :service_unavailable
          return
        end

        # if campus explore is built, prepare a personalized version
        prepare_personal_explore(simple_scores, announcement_scores, athletic_scores)
      end # end index method

      private

      def prepare_personal_explore(simple_scores, announcement_scores, athletic_scores)
        #### Normal Explore operations ####

        # save all events that user is attending to remove it from explore
        user_events = EventAttendee.where(user_id: auth_inst_id, category: 'simple').pluck(:event_attended)
        user_announcements = Announcement.where(user_id: auth_inst_id).pluck(:id)

        # personalize simple event and announcement scores
        personal_simple_scores, personal_announcement_scores, personal_athletic_scores = personalize_scores(simple_scores, announcement_scores, athletic_scores)

        ### Scale announcement scores to match event scores ###
        personal_announcement_scores = scale_scores_to_simple_events(personal_announcement_scores, personal_simple_scores)

        # get top scored events/announcements
        explore_ids = []
        @simple_explore_scores = {}
        @announcement_explore_scores = {}
        @athletic_explore_scores = {}

        # top scores of each explore array
        se_score = personal_simple_scores.pop
        ann_score = personal_announcement_scores.pop
        ath_score = personal_athletic_scores.pop

        # build top explore items list
        # check next element of each array and take the higher score
        ### run until the arrays are all empty ###
        until personal_simple_scores.empty? && personal_announcement_scores.empty? && personal_athletic_scores.empty?

          # default comparison values for when arrays start becoming emptied
          se_score ||= [0, 0]
          ann_score ||= [0, 0]
          ath_score ||= [0, 0]

          if se_score[1] >= ann_score[1] && se_score[1] >= ath_score[1]
            #### simple event has highest score ####
            # check if event was organized by current user
            unless user_events.include?(se_score[0])
              explore_ids << ['SimpleEvent', se_score[0]]
              @simple_explore_scores[se_score[0]] = se_score[1]
            end

            # get next highest score in array
            se_score = personal_simple_scores.pop

          elsif ann_score[1] >= ath_score[1]
            ####  announcement has highest score ####
            # check if announcement was posted by current user
            unless user_announcements.include?(ann_score[0])
              explore_ids << ['Announcement', ann_score[0]]
              @announcement_explore_scores[ann_score[0]] = ann_score[1]
            end

            # get next highest score in array
            ann_score = personal_announcement_scores.pop

          else
            #### athletic event has highest score ####
            explore_ids << ['AthleticEvent', ath_score[0]]
            @athletic_explore_scores[ath_score[0]] = ath_score[1]

            # get next highest score in array
            ath_score = personal_athletic_scores.pop
          end
          break if explore_ids.size >= NUMBER_OF_EXPLORE_ITEMS
        end

        # split up announcement / simple event ids for db query
        announcement_ids = []
        simple_event_ids = []
        athletic_event_ids = []

        # sorting explore items by type
        explore_ids.each do |id|
          if id[0] == 'SimpleEvent'
            simple_event_ids << id[1]
          elsif id[0] == 'Announcement'
            announcement_ids << id[1]
          elsif id[0] == 'AthleticEvent'
            athletic_event_ids << id[1]
          end
        end

        # query db for the correct explore items
        @explore_events = SimpleEvent.where(id: simple_event_ids).where.not(user_id: auth_user_id)
        @explore_announcements = Announcement.where(id: announcement_ids).where.not(user_id: auth_user_id)
        @explore_athletics = AthleticEvent.where(id: athletic_event_ids)

        # split up likes
        @likes_for_explore_events = get_likes_for_type('SimpleEvent', simple_event_ids)
        @likes_for_explore_announcements = get_likes_for_type('Announcement', announcement_ids)
        @likes_for_explore_athletics = get_likes_for_type('AthleticEvent', athletic_event_ids)
      end

      def run_builder
        # trigger campus explore calculation, or perform manually.
        Explore::Builder.perform_async

        # send back a status code
        response.headers['Retry-After'] = 10 # indicated a retry time of 10 seconds. could make this more dynamic
        render status: :service_unavailable, json: { errors: ['campus explore feed isn\'t currently cached'] }.to_json
      end # end run_builder method

      def personalize_scores(simple_scores, announcement_scores, athletic_scores)
        personalizer = Personalizer.new
        personal_simple_scores = personalizer.perform_events(SimpleEvent, simple_scores,
                                                             auth_user_id, auth_inst_id)
        personal_announcement_scores =  personalizer.perform_announcements(announcement_scores,
                                                                           auth_user_id, auth_inst_id)
        personal_athletic_scores = personalizer.perform_events(AthleticEvent, athletic_scores,
                                                               auth_user_id, auth_inst_id)

        [personal_simple_scores, personal_announcement_scores, personal_athletic_scores]
      end # end personalize_scores

      def scale_scores_to_simple_events(scale_these, to_these)
        ## se = simple events
        ## ann = announcements
        ann_scores = scale_these.collect(&:last)
        se_scores = to_these.collect(&:last)

        ann_score_stats = DescriptiveStatistics::Stats.new(ann_scores)
        se_score_stats = DescriptiveStatistics::Stats.new(se_scores)

        ann_mean = ann_score_stats.mean
        ann_std_dev = ann_score_stats.standard_deviation || 1
        se_mean = se_score_stats.mean
        se_std_dev = se_score_stats.standard_deviation || 1

        # scaling every announcement score to the simple event scores
        scale_these.each do |ann|
          announcement_z = (ann[1] - ann_mean) / ann_std_dev
          ann[1] = se_mean + (announcement_z * se_std_dev)
        end

        scale_these
      end # end scale_scores_to_simple_events

      def get_likes_for_type(type, ids)
        likes_for_this_type = {}

        all_likes = Like.where(likeable_type: type, likeable_id: ids).pluck(:likeable_id, :liker_id)

        all_likes.each do |like|
          if likes_for_this_type[like[0]]
            likes_for_this_type[like[0]] << like[1]
          else
            likes_for_this_type[like[0]] = [like[1]]
          end
        end

        likes_for_this_type
      end # end get_likes method
    end # end explore controller
  end # end v1 module
end # end api module
