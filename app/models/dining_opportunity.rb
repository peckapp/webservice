class DiningOpportunity < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  # home institution for this dining opportunity #
  belongs_to :institution #

  # opportunities for these dining periods #
  has_many :dining_periods #

  # dining places #
  has_and_belongs_to_many :dining_places, :join_table => :dining_opportunities_dining_places #

  # available menu items #
  has_many :menu_items #

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :dining_opportunity_type, :presence => true
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validate :correct_dining_opportunity_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  def earliest_start_latest_end(day_of_week)
    early = earliest_start(day_of_week)
    late = latest_end(day_of_week)

    if ! early.blank? && ! late.blank?
      if early.hour > late.hour
        late = late + 1.days
      end
    end
    return [early,late]
  end

  private

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

      return Util.date_time_for_week_day(day_of_week, earliest)

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

      return Util.date_time_for_week_day(day_of_week, latest)

    end


    def correct_dining_opportunity_types
      is_correct_type(dining_opportunity_type, String, "string", :dining_opportunity_type)
    end
  end
