module Explore
  class EventAnalyzer
    include Sidekiq::Worker

    def top_friends(user_id)

      # all circles that specified user is part of
      user_circles = CircleMember.where(user_id: user_id, accepted: true).pluck(:circle_id)

      # array of all members of user_circles (including repeats)
      all_circle_friends = CircleMember.where(circle_id: user_circles).where.not(user_id: user_id).pluck



    end

    def personalize



    end
  end
end
