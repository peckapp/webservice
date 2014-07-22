class DiningPeriod < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  # dining periods for these places
  belongs_to :dining_place #

  # dining periods for these opportunities
  belongs_to :dining_opportunity #

  # Institution
  belongs_to :institution

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates :day_of_week, :numericality => { :only_integer => true }, :allow_nil => true
  validates :dining_opportunity_id, :numericality => { :only_integer => true }, :allow_nil => true
  validates :dining_place_id, :numericality => { :only_integer => true }, :allow_nil => true
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validate :correct_dining_period_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  # returns the start_time for the current week for this period
  def cur_week_start_time
    Util.date_time_for_week_day(day_of_week, start_time)
  end

  def cur_week_end_time
    Util.date_time_for_week_day(day_of_week, end_time)
  end

  private

    def correct_dining_period_types
      is_correct_type(start_time, Time, "time", :start_time)
      is_correct_type(end_time, Time, "time", :end_time)
    end
end
