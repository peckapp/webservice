# nests all explore workers within their own module
module Explore
  # sub worker that analyses a specific announcement
  class AnnouncementAnalyzer

    def perform(id, inst_id)
      the_announcement = Announcement.find(id)

      # time at which announcement was created
      time_of_announcement = the_announcement.created_at

      # number of views and likes
      view_count = EventView.where(category: "announcement", event_viewed: the_announcement.id).count
      like_count = the_announcement.likers(User).count

      # just for scraped events??? think more about this
      if the_announcement.category == "athletic"
        subscriber_count = AthleticTeam.find(the_event.athletic_team_id).subscriber_count
        counts = AthleticTeam.all.pluck(:subscriber_count)
      elsif the_announcement.category == "department"
        subscriber_count = Department.find(the_event.organizer_id).subscriber_count
        counts = Department.all.pluck(:subscriber_count)
      elsif the_announcement.category == "club"
        subscriber_count = Club.find(the_event.organizer_id).subscriber_count
        counts = Club.all.pluck(:subscriber_count)
      else
        subscriber_count = 0
      end

      # comment values
      all_comments = Comment.where(category: "announcement", comment_from: the_announcement.id)
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

      # sum weights
      peck_score = weights.temporal_proximity(time_of_announcement, true) +
                   weights.event_views(view_count) +
                   weights.event_likes(like_count) +
                   weights.comments(unique_commentors, comments) +
                   subscription_score

      # RETURN THE ANNOUNCEMENT'S PECK SCORE
      if peck_score > 0.01
        peck_score
      else
        0
      end
    end
  end
end
