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

        if simple_scores.blank? || announcement_scores.blank? || athletic_scores.blank?
          # trigger campus explore calculation, or perform manually.
          Explore::Builder.perform_async(auth_inst_id)

          # send back a status code
          response.headers['Retry-After'] = 10 # indicated a retry time of 10 seconds. could make this more dynamic
          render status: :service_unavailable, json: { errors: ['campus explore feed isn\'t currently cached'] }.to_json
        else
          # save all events that user is attending to remove it from explore
          user_events = EventAttendee.where(user_id: auth_inst_id, category: 'simple').pluck(:event_attended)
          user_announcements = Announcement.where(user_id: auth_inst_id).pluck(:id)

          # personalize simple event and announcement scores
          personalizer = Personalizer.new
          personal_simple_scores = personalizer.perform_events(simple_scores, auth_user_id, auth_inst_id)
          personal_announcement_scores =  personalizer.perform_announcements(announcement_scores, auth_user_id, auth_inst_id)
          personal_athletic_scores = personalizer.perform_events(athletic_scores, auth_user_id, auth_inst_id)

          ### Scale announcement scores to z-score ###
          ## se = simple events
          ## ann = announcements
          se_scores = personal_simple_scores.collect(&:last)
          ann_scores = personal_announcement_scores.collect(&:last)

          se_score_stats = DescriptiveStatistics::Stats.new(se_scores)
          ann_score_stats = DescriptiveStatistics::Stats.new(ann_scores)

          se_mean = se_score_stats.mean
          se_std_dev = se_score_stats.standard_deviation
          ann_mean = ann_score_stats.mean
          ann_std_dev = ann_score_stats.standard_deviation

          # scaling every announcement score to the simple event scores
          personal_announcement_scores.each do |ann|
            announcement_z = (ann[1] - ann_mean) / ann_std_dev
            ann[1] = se_mean + (announcement_z * se_std_dev)
          end

          # get top scored events/announcements
          explore_ids = []
          @simple_explore_scores = {}
          @announcement_explore_scores = {}
          @athletic_explore_scores = {}

          # enumerators to iterate over each array AS NEEDED
          ann_enumerator = personal_announcement_scores.to_enum
          se_enumerator = personal_simple_scores.to_enum
          ath_enumerator = personal_athletic_scores.to_enum

          # top scores of each explore array
          se_score = se_enumerator.next
          ann_score = ann_enumerator.next
          ath_score = ath_enumerator.next

          # booleans to prevent StopIteration exception
          some_simple_events_left = true
          some_announcements_left = true
          some_athletic_events_left = true

          # check next element of each array and take the higher score
          while explore_ids.size < NUMBER_OF_EXPLORE_ITEMS
            if some_simple_events_left && se_score[1] > ann_score[1] && se_score[1] > ath_score[1]
              # check if event was organized by current user
              unless user_events.include?(se_score[0])
                explore_ids << ['SimpleEvent', se_score[0]]
                @simple_explore_scores[se_score[0]] = se_score[1]
              end

              # make sure enumerator has a next element
              begin
                se_score = se_enumerator.next
              rescue StopIteration
                some_simple_events_left = false
              end
            elsif some_announcements_left && ann_score[1] > se_score[1] && ann_score[1] > ath_score[1]
              # check if announcement was posted by current user
              unless user_announcements.include?(ann_score[0])
                explore_ids << ['Announcement', ann_score[0]]
                @announcement_explore_scores[ann_score[0]] = ann_score[1]
              end

              # make sure enumerator has a next element
              begin
                ann_score = ann_enumerator.next
              rescue StopIteration
                some_announcements_left = false
              end
            elsif some_athletic_events_left
              explore_ids << ['AthleticEvent', ath_score[0]]
              @athletic_explore_scores[ath_score[0]] = ath_score[1]

              # make sure enumerator has a next element
              begin
                ath_score = ath_enumerator.next
              rescue StopIteration
                some_athletic_events_left = false
              end
            end

            break unless some_simple_events_left || some_announcements_left || some_athletic_events_left
          end

          # split up announcement / simple event ids for db query
          announcement_ids = []
          simple_event_ids = []
          athletic_event_ids = []
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

          # initialize hash mapping events to arrays of likers
          @likes_for_explore_events = {}
          @likes_for_explore_announcements = {}
          @likes_for_explore_athletics = {}

          all_simple_likes = Like.where(likeable_type: 'SimpleEvent', likeable_id: simple_event_ids).pluck(:likeable_id, :liker_id)
          all_announcement_likes = Like.where(likeable_type: 'Announcement', likeable_id: announcement_ids).pluck(:likeable_id, :liker_id)
          all_athletic_likes = Like.where(likeable_type: 'AthleticEvent', likeable_id: athletic_event_ids).pluck(:likeable_id, :liker_id)

          all_simple_likes.each do |like|
            if @likes_for_explore_events[like[0]]
              @likes_for_explore_events[like[0]] << like[1]
            else
              @likes_for_explore_events[like[0]] = [like[1]]
            end
          end # end likes iteration

          all_announcement_likes.each do |like|
            if @likes_for_explore_announcements[like[0]]
              @likes_for_explore_announcements[like[0]] << like[1]
            else
              @likes_for_explore_announcements[like[0]] = [like[1]]
            end
          end # end announcement likes iteration

          all_athletic_likes.each do |like|
            if @likes_for_explore_athletics[like[0]]
              @likes_for_explore_athletics[like[0]] << like[1]
            else
              @likes_for_explore_athletics[like[0]] = [like[1]]
            end
          end # end announcement likes iteration
        end # end scores blank if else
      end # end index method
    end # end explore controller
  end # end v1 module
end # end api module
