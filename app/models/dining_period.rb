class DiningPeriod < ActiveRecord::Base
  include ModelNormalValidations

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

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :day_of_week, numericality: { only_integer: true }, allow_nil: true
  validates :dining_opportunity_id, numericality: { only_integer: true }, allow_nil: true
  validates :dining_place_id, numericality: { only_integer: true }, allow_nil: true
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validate :correct_dining_period_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  # returns the start_date for the current week for this period
  def cur_week_start_date
    Util.date_time_for_week_day(day_of_week, start_date)
  end

  def cur_week_end_date
    Util.date_time_for_week_day(day_of_week, end_date)
  end

  private

  def correct_dining_period_types
    is_correct_type(start_date, Time, 'time', :start_date)
    is_correct_type(end_date, Time, 'time', :end_date)
  end
end
