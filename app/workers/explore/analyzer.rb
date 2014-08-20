module Explore
  class Analyzer
    # include Sidekiq::Worker

    def perform(id, inst_id, model)
      target = model.find(id)

      # time, views, attendees of event or announcement
      # announcement = no attendees
      if model == Announcement
        cat_string = "announcement"
        time_of = target.created_at
        attendee_count = 0
        view_count = EventView.where(category: cat_string, event_viewed: target.id).count

        target_origin = target.poster_id

      elsif model == AthleticEvent
        cat_string = "athletic"
        time_of = target.start_date
        attendee_count = EventAttendee.where(category: cat_string, event_attended: target.id).count
        view_count = EventView.where(category: cat_string, event_viewed: target.id).count

        target_origin = target.athletic_team_id

      else
        cat_string = "simple"
        time_of = target.start_date
        attendee_count = EventAttendee.where(category: "simple", event_attended: target.id).count
        view_count = EventView.where(category: "simple", event_viewed: target.id).count

        target_origin = target.organizer_id

      end

      # number of likes
      like_count = target.likers(User).count

      # this is to get subscription data from correct table below
      if model == AthleticEvent
        sub_model = AthleticTeam
      elsif target.category == "department"
        sub_model = Department
      elsif target.category == "club"
        sub_model = Club
      end

      # subscription data
      if sub_model
        subscriber_count = sub_model.find(target_origin).subscriber_count
        counts = sub_model.all.pluck(:subscriber_count)
      else
        subscriber_count = 0
      end

      # comment values
      all_comments = Comment.where(category: cat_string, comment_from: target.id)
      comments = all_comments.count
      unique_commentors = all_comments.pluck(:user_id).uniq.count

      # weights score calculator
      weights = Weights.new(inst_id)

      if subscriber_count.blank? || counts.blank? || subscriber_count == 0
        subscription_score = 0
      else
        counts_array = DescriptiveStatistics::Stats.new(counts)
        if counts_array
          mean_subscribers = counts_array.mean
          standard_dev = counts_array.standard_deviation

          # score for subscriptions
          subscription_score = weights.subscriptions(subscriber_count, mean_subscribers, standard_dev)
        else
          subscription_score = 0
        end
      end

      # calculate invidual scoring
      if model == Announcement
        attendee_score = 0
        time_score = weights.temporal_proximity(time_of, true)
      else
        attendee_score = weights.attendees(attendee_count)
        time_score = weights.temporal_proximity(time_of, false)
      end

      view_score = weights.event_views(view_count)
      like_score = weights.event_likes(like_count)
      comment_score = weights.comments(unique_commentors, comments)

      # sum of scores
      peck_score = time_score + attendee_score + view_score + like_score + comment_score + subscription_score

      # RETURN THE EVENT'S PECK SCORE
      if peck_score > 0.01
        peck_score
      else
        0
      end
    end
  end
end
