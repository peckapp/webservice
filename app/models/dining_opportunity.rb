class DiningOpportunity < ActiveRecord::Base
# verified
  ### home institution for this dining opportunity ###
  belongs_to :institution #

  ### opportunities for these dining periods ###
  has_many :dining_periods #

  ### dining places ###
  has_and_belongs_to_many :dining_places, :join_table => :dining_opportunities_dining_places #

  ### available menu items ###
  has_many :menu_items #


  # methods to sort through earliest/latest times
  def earliest_start(day_of_week)
    start_times = DiningPeriod.where({ "dining_periods.dining_opportunity_id" => self.id, "dining_periods.day_of_week" => day_of_week }).pluck(:start_time)

    earliest = nil

    for t in start_times
      if earliest == nil
        earliest = t
      elsif t < earliest
        earliest = t
      end
    end

    earliest

  end

  def latest_end(day_of_week)
    end_times = DiningPeriod.where({ "dining_periods.dining_opportunity_id" => self.id, "dining_periods.day_of_week" => day_of_week }).pluck(:end_time)

    latest = nil

    for t in end_times
      if latest == nil
        latest = t
      elsif t > latest
        latest = t
      end
    end

    latest

  end


end
