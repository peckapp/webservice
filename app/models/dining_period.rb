class DiningPeriod < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Associations ###
  # dining periods for these places
  belongs_to :dining_place #

  # dining periods for these opportunities
  belongs_to :dining_opportunity #

  # Institution
  belongs_to :institution
  ####################

  ### Validations ###
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates :day_of_week, :numericality => { :only_integer => true }, :allow_nil => true
  validates :dining_opportunity_id, :numericality => { :only_integer => true }, :allow_nil => true
  validates :dining_place_id, :numericality => { :only_integer => true }, :allow_nil => true
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validate :correct_dining_period_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_dining_period
  # before_create :sanitize_dining_period
  # before_update :sanitize_dining_period
  #################

  ### Methods ###

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
  #
  # def sanitize_dining_period
  #   sanitize_everything(attributes)
  # end

  # private
  #   attributes = [id, start_time, end_time, day_of_week, dining_opportunity_id, dining_place_id, institution_id, created_at, updated_at]
end
