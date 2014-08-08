# provides the weights needed for calculating explore scores
class Weights
  #### CONSTANTS ####

  # perfect score for any single weight
  FULL_SCORE = 100

  # Minimum number of users
  MIN_USERS = 100

  ###################

  def temporal_proximity(time)
    tdist = time - Time.now
    if tdist < 24.hours
      # until the end of the day, constant full score
      FULL_SCORE
    elsif tdist < 7.days
      # during a bit less than the next week
      FULL_SCORE - (40 / 6.days) * (tdist - 24.hours)
    else
      # greater than a week from now
      # origin for the function starts at 5 days from now
      60 * 0.9**(tdist - 7.days)
    end
  end

  def attendees(count, inst_id)
    users = active_users(inst_id)
    (400 * count) / users
  end

  def event_views(count, inst_id)
    users = active_users(inst_id)
    (32 * (count**1.5)) / users**0.25
  end

  def event_likes(count, inst_id)
    users = active_users(inst_id)
    (333 * count) / users
  end

  def subscriptions(subscribers, inst_id)
    users = active_users(inst_id)
    # just a placeholder
    subscribers / users
  end

  def comments(uniques, comments, inst_id)
    users = active_users(inst_id)
    ((0.7 * (250 * uniques**1.5) / users) +
      (0.3 * (85 * comments**1.5) / users))
  end

  protected

  def active_users(inst_id)
    # may want to add further customization if certain users are not actively involved in their accounts
    users = User.where(institution_id: inst_id).where('email IS NOT NULL').count
    return users if users > MIN_USERS
    MIN_USERS
  end
end