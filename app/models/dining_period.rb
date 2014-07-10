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
  # validates :start_time, :presence => true
  # validates :end_time, :presence => true
  # validates :day_of_week, :numericality => true, :allow_nil => true
  # validates :dining_opportunity_id, :numericality => true, :allow_nil => true
  # validates :dining_place_id, :numericality => true, :allow_nil => true
  # validates :institution_id, :presence => true, :numericality => true
  # validate :correct_dining_period_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_dining_period
  # before_create :sanitize_dining_period
  # before_update :sanitize_dining_period
  #################

  ### Methods ###
  # def correct_dining_period_types
  #   is_correct_type(start_time, Time, "time", :start_time)
  #   is_correct_type(end_time, Time, "time", :end_time)
  #   is_correct_type(day_of_week, Fixnum, "fixnum", :day_of_week)
  #   is_correct_type(dining_opportunity_id, Fixnum, "fixnum", :dining_opportunity_id)
  #   is_correct_type(dining_place_id, Fixnum, "fixnum", :dining_place_id)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  # end
  #
  # def sanitize_dining_period
  #   sanitize_everything(attributes)
  # end

  # private
  #   attributes = [id, start_time, end_time, day_of_week, dining_opportunity_id, dining_place_id, institution_id, created_at, updated_at]
end
