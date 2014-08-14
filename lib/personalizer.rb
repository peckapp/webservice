class Personalizer

  NUMBER_OF_FRIENDS = 10
  NUMBER_OF_TOP_SUBSCRIBERS = 10
  MINIMUM_SUBSCRIPTIONS = 5

  MAX_FRIENDS_BOOST = 200
  MAX_SUB_BOOST = 200
  MAX_FRIEND_SCORE = 40
  MIN_CIRCLES = 3

  def perform(event_scores, user_id, inst_id)

    top_circle_friends = top_friends(user_id)
    top_similar_subscribers = similar_subscribers(user_id, inst_id)
    circle_count = CircleMember.where(user_id: user_id).count

    # @user_circles gets set in top_friends method
    if @user_circles.count >= MIN_CIRCLES
      circle_count = @user_circles.count
    else
      circle_count = MIN_CIRCLES
    end

    # weights calculator
    weights = Weights.new(inst_id)

    # all attendees saved to avoid a database call for every event
    event_ids = []
    attendees_for_event = {}
    event_scores.each { |event| event_ids << event[0] }
    all_attendees = EventAttendee.where(event_attended: event_ids).pluck(:event_attended, :user_id)

    all_attendees.each do |att|
      if attendees_for_event[att[0]]
        attendees_for_event[att[0]] << att[1]
      else
        attendees_for_event[att[0]] = [att[1]]
      end
    end

    event_scores.each do |event|

      attendees = attendees_for_event[event[0]]

      ## Scoring boost for circle friends
      friend_boost = 0
      top_circle_friends.each do |friend|

        if attendees != nil && attendees.include?(friend[0])
          if weights.circle_friend_boost(friend[1], circle_count) > MAX_FRIEND_SCORE
            friend_score = MAX_FRIEND_SCORE
          else
            friend_score = weights.circle_friend_boost(friend[1], circle_count)
          end

          friend_boost += friend_score
        end
      end

      if friend_boost > MAX_FRIENDS_BOOST
        event_scores[event[0]] += MAX_FRIEND_BOOST
      else
        event_scores[event[0]] += friend_boost
      end

      ## Scoring boost for similar subscribers
      subs_boost = 0
      top_similar_subscribers.each do |subs|
        if attendees != nil && attendees.include?(subs[0])
          subs_boost += MAX_SUB_BOOST/NUMBER_OF_TOP_SUBSCRIBERS
        end
      end

      event_scores[event[0]] += subs_boost

    end

    new_scores = event_scores.sort_by &:last
    new_scores.reverse
  end

  # returns an array of tuples of friends who appear most in a user's circles with the
  # number of times they appear in the circles (bonus given if the circle friend was invited
  # by the user)
  def top_friends(user_id)

    # all circles that specified user is part of
    @user_circles = CircleMember.where(user_id: user_id, accepted: true).pluck(:circle_id)

    # array of all members of user_circles (including repeats)
    all_circle_friends = CircleMember.where(circle_id: @user_circles).where.not(user_id: user_id).pluck(:user_id, :invited_by)

    ranked_friends = {}

    if all_circle_friends != nil
      all_circle_friends.each do |friend|

        if ranked_friends[friend[0]]
          if ranked_friends[friend[1]] == user_id
            ranked_friends[friend[0]] += 1.5
          else
            ranked_friends[friend[0]] += 1
          end
        else
          if ranked_friends[friend[1]] == user_id
            ranked_friends[friend[0]] = 1.5
          else
            ranked_friends[friend[0]] = 1
          end
        end

      end
    else
      # no friends, return empty array
      return []
    end

    # sort hash from small to big and reverse order
    ordered = ranked_friends.sort_by &:last
    ranked_friend_array = ordered.reverse

    # top n friends array where n = NUMBER OF FRIENDS
    top_friends = []
    if ranked_friend_array.size < NUMBER_OF_FRIENDS
      (0...ranked_friend_array.size).each do |n|
        top_friends << ranked_friend_array[n]
      end
    else
      (0...NUMBER_OF_FRIENDS).each do |n|
        top_friends << ranked_friend_array[n]
      end
    end

    # return array of tuples with user ID and how many times they appear
    top_friends
  end

  # subscribers impact on an event's peck score
  def similar_subscribers(user_id, institution_id)

    user_subscriptions = Subscription.where(user_id: user_id).pluck(:category, :subscribed_to)

    all_subscribers = Subscription.where(institution_id: institution_id).where.not(user_id: user_id).pluck(:user_id, :category, :subscribed_to).shuffle

    similar_subscribers = {}
    top_subscribers = {}

    # should NEVER be nil but add check anyways just in case
    if all_subscribers != nil
      all_subscribers.each do |subscriber|

        current_sub = [subscriber[1], subscriber[2]]
        if user_subscriptions.include? current_sub

          # increment number of subscriptions in common
          if similar_subscribers[subscriber[0]]
            similar_subscribers[subscriber[0]] += 1
          else
            similar_subscribers[subscriber[0]] = 1
          end

          # if they have the minimum number of subscriptions in common
          if similar_subscribers[subscriber[0]] >= MINIMUM_SUBSCRIPTIONS
            top_subscribers[subscriber[0]] = similar_subscribers[subscriber[0]]
          end

          if top_subscribers.size >= NUMBER_OF_TOP_SUBSCRIBERS
            return top_subscribers.to_a
          end
        end
      end
    else
      return []
    end

    # return hash of top similar subscribers
    top_subscribers.to_a
  end
end
