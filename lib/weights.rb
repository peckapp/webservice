# provides the weights needed for calculating explore scores
class Weights
  #### CONSTANTS ####

  ###################

  def temporal_proximity(time)
    tdist = time - Time.now
    if tdist < 24.hours
      # until the end of the day, constant full score
      100
    elsif tdist < 7.days
      # during a bit less than the next week
      100 - (40 / 6.days) * (tdist - 24.hours)
    else
      # greater than a week from now
      # origin for the function starts at 5 days from now
      20 * 0.5**(tdist - 6.days)
    end
  end

  def attendees(count, inst_id)
    u = active_users(inst_id)
    (400 * count) / u
  end

  def event_views(count, inst_id)
    u = active_users(inst_id)
    (32 * (count**1.5)) / u**0.25
  end

  def event_likes(count, inst_id)
    u = active_users(inst_id)
    (333 * count) / u
  end

  def subscriptions(subscribers, inst_id)
    u = active_users(inst_id)
    # just a placeholder
    subscribers / u
  end

  def comments(uniques, comments, inst_id)
    u = active_users(inst_id)
    ((0.7 * (250 * uniques**1.5) / u) +
      (0.3 * (85 * comments**1.5) / u))
  end

  protected

  def active_users(inst_id)
    # may want to add further customization if certain users are not actively involved in their accounts
    u = User.where(institution_id: inst_id).where('email IS NOT NULL').count
    return u if u > 100
    100
  end
end
