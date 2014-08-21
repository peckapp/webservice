# personalizes the scores of the campus explore feed for a specific user
class Personalizer
  NUMBER_OF_FRIENDS = 10
  NUMBER_OF_TOP_SUBSCRIBERS = 10
  MINIMUM_SUBSCRIPTIONS = 5

  MAX_EVENTS_FRIENDS_BOOST = 200
  MAX_EVENTS_SUB_BOOST = 200
  MAX_ANNOUNCEMENTS_FRIENDS_BOOST = 300
  MAX_ANNOUNCEMENTS_SUB_BOOST = 300
  MAX_FRIEND_SCORE = 40
  MIN_CIRCLES = 3

  ###############################
  ##                           ##
  ##          EVENTS           ##
  ##                           ##
  ###############################

  def perform_events(event_scores = [], user_id, inst_id)
    top_circle_friends = top_friends(user_id)
    top_similar_subscribers = similar_subscribers(user_id, inst_id)

    # @user_circles gets set in top_friends method
    circle_count = user_circle_count(@user_circles.count, MIN_CIRCLES)

    # weights calculator
    weights = Weights.new(inst_id)

    # all attendees saved to avoid a database call for every event
    ###############################################
    ## NEED TO HANDLE EVENT CATEGORY DONT FORGET ##
    event_ids = []
    attendees_for_event = {}
    event_scores.each { |event| event_ids << event[0] }

    # associate each event to its attendees
    all_attendees = EventAttendee.where(event_attended: event_ids).pluck(:event_attended, :user_id)
    all_attendees.each do |att|
      if attendees_for_event[att[0]]
        attendees_for_event[att[0]] << att[1]
      else
        attendees_for_event[att[0]] = [att[1]]
      end
    end

    # get all values for the manual booster scores now to avoid making too many db calls later
    boosters = Hash[SimpleEvent.where(id: event_ids).pluck(:id, :default_score)]

    event_scores.each do |event|

      attendees = attendees_for_event[event[0]]

      ## Scoring boost for circle friends
      friend_score = 0
      friend_boost = 0
      top_circle_friends.each do |friend|

        if !attendees.nil? && attendees.include?(friend[0])
          if weights.circle_friend_boost(friend[1], circle_count) > MAX_FRIEND_SCORE
            friend_score = MAX_FRIEND_SCORE
          else
            friend_score = weights.circle_friend_boost(friend[1], circle_count)
          end

          friend_boost += friend_score
        end
      end

      if friend_boost > MAX_EVENTS_FRIENDS_BOOST
        event_scores[event[0]] += MAX_EVENTS_FRIEND_BOOST
      else
        event_scores[event[0]] += friend_boost
      end

      ## Scoring boost for similar subscribers
      subs_boost = 0
      top_similar_subscribers.each do |subs|
        if !attendees.nil? && attendees.include?(subs[0])
          subs_boost += MAX_EVENTS_SUB_BOOST / NUMBER_OF_TOP_SUBSCRIBERS
        end
      end

      event_scores[event[0]] += subs_boost

      # random booster
      event_scores[event[0]] += weights.random_booster

      # default score
      if boosters[event[0]]
        event_scores[event[0]] += boosters[event[0]]
      end

    end

    new_scores = event_scores.sort_by &:last
    new_scores.reverse
  end

  ###############################
  ##                           ##
  ##       ANNOUNCEMENTS       ##
  ##                           ##
  ###############################

  def perform_announcements(announcement_scores = [], user_id, inst_id)
    # save top circle friends and top subs friends
    top_circle_friends = top_friends(user_id)
    top_similar_subscribers = similar_subscribers(user_id, inst_id)

    # @user_circles gets set in top_friends method
    circle_count = user_circle_count(@user_circles.count, MIN_CIRCLES)

    # weights calculator
    weights = Weights.new(inst_id)

    # array/hashes for storing ids, likers, and commenters
    announcement_ids = []
    likers_for_announcement = {}
    commenters_for_announcement = {}

    announcement_scores.each { |ann| announcement_ids << ann[0] }

    # associate each announcement to its likers
    all_likers = Like.where(likeable_type: "Announcement").pluck(:likeable_id, :liker_id)
    all_likers.each do |like|
      if likers_for_announcement[like[0]]
        likers_for_announcement[like[0]] << like[1]
      else
        likers_for_announcement[like[0]] = [like[1]]
      end
    end

    # associate each announcement to its commentors
    all_commenters = Comment.where(category: "announcement").pluck(:comment_from, :user_id)
    all_commenters.each do |comment|
      if commenters_for_announcement[comment[0]] && ! commenters_for_announcement[comment[0]].include?(comment[1])
        commenters_for_announcement[comment[0]] << comment[1]
      else
        commenters_for_announcement[comment[0]] = [comment[1]]
      end
    end

    # get all default scores for announcements in range
    boosters = Hash[Announcement.where(id: announcement_ids).pluck(:id, :default_score)]

    # personalize score for each announcement
    announcement_scores.each do |ann|

      # fetch likers and commenters for this announcement
      likers = likers_for_announcement[ann[0]]
      commenters = commenters_for_announcement[ann[0]]

      ## Scoring boost for circle friends
      friend_like_score = 0
      friend_comment_score = 0
      friend_boost = 0
      top_circle_friends.each do |friend|

        # likers scoring boost
        if !likers.nil? && likers.include?(friend[0])
          if weights.circle_friend_boost(friend[1], circle_count) > MAX_FRIEND_SCORE
            friend_like_score = MAX_FRIEND_SCORE
          else
            friend_like_score = weights.circle_friend_boost(friend[1], circle_count)
          end

          friend_boost += friend_like_score
        end

        # commenters scoring boost
        if !commenters.nil? && commenters.include?(friend[0])
          if weights.circle_friend_boost(friend[1], circle_count) > MAX_FRIEND_SCORE
            friend_comment_score = MAX_FRIEND_SCORE
          else
            friend_comment_score = weights.circle_friend_boost(friend[1], circle_count)
          end

          friend_boost += friend_comment_score
        end
      end # end of top circle friends loop

      # place cap on top friends booster
      if friend_boost > MAX_ANNOUNCEMENTS_FRIENDS_BOOST
        announcement_scores[ann[0]] += MAX_ANNOUNCEMENTS_FRIEND_BOOST
      else
        announcement_scores[ann[0]] += friend_boost
      end

      ## Scoring boost for similar subscribers
      subs_boost = 0
      top_similar_subscribers.each do |subs|
        # boost for likes
        if !likers.nil? && likers.include?(subs[0])
          subs_boost += MAX_ANNOUNCEMENTS_SUB_BOOST / NUMBER_OF_TOP_SUBSCRIBERS
        end

        # boost for commenters
        if !commenters.nil? && commenters.include?(subs[0])
          subs_boost += MAX_ANNOUNCEMENTS_SUB_BOOST / NUMBER_OF_TOP_SUBSCRIBERS
        end
      end # end of subscribers loop

      # place cap on subscriptions booster
      if friend_boost > MAX_ANNOUNCEMENTS_SUB_BOOST
        announcement_scores[ann[0]] += MAX_ANNOUNCEMENTS_SUB_BOOST
      else
        announcement_scores[ann[0]] += subs_boost
      end

      # random booster
      announcement_scores[ann[0]] += weights.random_booster

      # default score
      if boosters[ann[0]]
        announcement_scores[ann[0]] += boosters[ann[0]]
      end

    end

    new_scores = announcement_scores.sort_by &:last
    new_scores.reverse
  end

  ###############################
  ##                           ##
  ##    FRIENDS/SUBSCRIBERS    ##
  ##                           ##
  ###############################

  # returns an array of tuples of friends who appear most in a user's circles with the
  # number of times they appear in the circles (bonus given if the circle friend was invited
  # by the user)
  def top_friends(user_id)
    # all circles that specified user is part of
    @user_circles = CircleMember.where(user_id: user_id, accepted: true).pluck(:circle_id)

    # array of all members of user_circles (including repeats)
    all_circle_friends = CircleMember.where(circle_id: @user_circles).where.not(user_id: user_id).pluck(:user_id, :invited_by)

    ranked_friends = {}

    if !all_circle_friends.nil?
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
    if !all_subscribers.nil?
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

  ###############################
  ##                           ##
  ##       HELPER METHODS      ##
  ##                           ##
  ###############################

  # make sure top friends are scored relative to a minimum number of circles
  def user_circle_count(current_count, min_count)
    if current_count >= min_count
      current_count
    else
      min_count
    end
  end
end
