# nests all explore workers within their own module
module Explore
  # sub worker that analyses a specific
  class EventAnalyzer
    include Sidekiq::Worker

    def perform(id, inst_id, model_str)
      # set model to AthleticEvent or SimpleEvent
      model = Util.class_from_string(model_str)

      the_event = model.find(id)

      # all necessary values to get this event's Peck Score
      time_of_event = the_event.start_date

      logger.info "MODEL STRING -----> #{model_str} <------"

      # if the model string contains the word simple then event is simple otherwise athletic
      if model_str.downcase["simple"]
        cat_string = "simple"
      else
        cat_string = "athletic"
      end

      # number of attendees, views, likes, and subscribers
      attendee_count = EventAttendee.where(category: cat_string, event_attended: the_event.id).count
      view_count = EventView.where(category: cat_string, event_viewed: the_event.id).count
      like_count = the_event.likers.count

      # just for scraped events??? think more about this
      if cat_string == "athletic"
        subscriber_count = AthleticTeam.find(the_event.athletic_team_id).subscriber_count
      elsif the_event.department_id
        subscriber_count = Department.find(the_event.department_id).subscriber_count
      elsif the_event.club_id
        subscriber_count = Club.find(the_event.club_id).subscriber_count
      else
        subscriber_count = 0
      end

      # comment values
      all_comments = Comment.where(category: cat_string, comment_from: the_event.id)
      comments = all_comments.count
      unique_commentors = all_comments.pluck(:user_id).uniq.count

      # sum weights
      peck_score = Weights.temporal_proximity(time_of_event) +
                   Weights.attendees(attendee_count, inst_id) +
                   Weights.event_views(view_count, inst_id) +
                   Weights.event_likes(like_count, inst_id) +
                   Weights.subscriptions(subscriber_count, inst_id) +
                   Weights.comments(unique_commentors, comment_count, inst_id)

      # RETURN THE EVENT'S PECK SCORE
      peck_score
    end
  end
end
