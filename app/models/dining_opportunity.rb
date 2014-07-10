class DiningOpportunity < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Associations ###
  # home institution for this dining opportunity #
  belongs_to :institution #

  # opportunities for these dining periods #
  has_many :dining_periods #

  # dining places #
  has_and_belongs_to_many :dining_places, :join_table => :dining_opportunities_dining_places #

  # available menu items #
  has_many :menu_items #
  ####################

  ### Validations ###
  # validates :dining_opportunity_type, :presence => true
  # validates :institution_id, :presence => true, :numericality => true
  # validate :correct_dining_opportunity_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_dining_opportunity
  # before_create :sanitize_dining_opportunity
  # before_update :sanitize_dining_opportunity
  #################

  ### Methods ###
  # def correct_dining_opportunity_types
  #   is_correct_type(dining_opportunity_type, String, "string", :dining_opportunity_type)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  # end
  #
  # def sanitize_dining_opportunity
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, dining_opportunity_type, institution_id, created_at, updated_at]


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

    return date_time_for_week_day(day_of_week, earliest)

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

    return date_time_for_week_day(day_of_week, latest)

  end

  private

    # DiningOpportunities are time-independant, so these methods deliver the proper DateTime for the specified week_day parameter coming from the controller

    def date_time_for_week_day(day_of_week, time)
      if ! day_of_week.blank? && ! time.blank?
        day = nearest_week_day(day_of_week)
        return day.change(hour: time.hour, min: time.min)
      end
    end

    def nearest_week_day(day_of_week)
      if ! day_of_week.blank?
        cur = DateTime.now.noon.wday
        # the amount to shift the date forward by
        shift = cur - day_of_week
        return DateTime.now.noon - shift.days
      end
    end
end
