# nests all explore workers within their own module
module Explore

  ### COMMENT HERE ###
  # currently running in a single block but could be split up
  # splitting up will require assessing race conditions and
  # possibly implementing our own lock

  # sub worker that analyses a specific
  class EventAnalyzer
    # include Sidekiq::Worker

    def perform(id, inst_id, model_str)

      # set model to AthleticEvent or SimpleEvent
      model = Util.class_from_string(model_str)

      the_event = model.find(id)

      # all necessary values to get this event's Peck Score
      time_of_event = the_event.start_date

      # if the model string contains the word simple then event is simple otherwise athletic
      if model_str.downcase["simple"]
        cat_string = "simple"
      else
        cat_string = "athletic"
      end

      # number of attendees, views, likes, and subscribers
      attendee_count = EventAttendee.where(category: cat_string, event_attended: the_event.id).count
      view_count = EventView.where(category: cat_string, event_viewed: the_event.id).count
      like_count = the_event.likers(User).count

      # just for scraped events??? think more about this
      if cat_string == "athletic"
        subscriber_count = AthleticTeam.find(the_event.athletic_team_id).subscriber_count
      elsif the_event.category == "department"
        subscriber_count = Department.find(the_event.organizer_id).subscriber_count
      elsif the_event.category == "club"
        subscriber_count = Club.find(the_event.organizer_id).subscriber_count
      else
        subscriber_count = 0
      end

      # comment values
      all_comments = Comment.where(category: cat_string, comment_from: the_event.id)
      comments = all_comments.count
      unique_commentors = all_comments.pluck(:user_id).uniq.count

      weights = Weights.new(inst_id)
      # sum weights
      peck_score = weights.temporal_proximity(time_of_event) +
                   weights.attendees(attendee_count) +
                   weights.event_views(view_count) +
                   weights.event_likes(like_count) +
                   weights.comments(unique_commentors, comments) #+
                   #weights.subscriptions(subscriber_count)

      # RETURN THE EVENT'S PECK SCORE
      peck_score
    end
  end
end
