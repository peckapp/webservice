module Explore
  class Personalizer
    include Sidekiq::Worker

    NUMBER_OF_FRIENDS = 10
    NUMBER_OF_TOP_SUBSCRIBERS = 5
    MINIMUM_SUBSCRIPTIONS = 3

    # returns an array of tuples of friends who appear most in a user's circles with the
    # number of times they appear in the circles (bonus given if the circle friend was invited
    # by the user)
    def top_friends(user_id)

      # all circles that specified user is part of
      user_circles = CircleMember.where(user_id: user_id, accepted: true).pluck(:circle_id)

      # array of all members of user_circles (including repeats)
      all_circle_friends = CircleMember.where(circle_id: user_circles).where.not(user_id: user_id).pluck(:user_id, :invited_by)

      ranked_friends = {}

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
      
      top_friends
    end

    # subscribers impact on an event's peck score
    def similar_subscribers(user_id, institution_id)

      user_subscriptions = Subscription.where(user_id: user_id).pluck(:category, :subscribed_to)

      all_subscribers = Subscription.where(institution_id: institution_id).where.not(user_id: user_id).pluck(:user_id, :category, :subscribed_to).shuffle

      similar_subscribers = {}
      top_subscribers = {}

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
            return top_subscribers
          end
        end
      end

      top_subscribers
    end

    def personalize



    end
  end
end
