class Location < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Validations ###
  # validates :institution_id, :presence => true, :numericality => true
  # validates :name, :presence => true
  # validate :correct_location_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_location
  # before_create :sanitize_location
  # before_update :sanitize_location
  #################

  ### Associations ###
  ### a location has just one institution ###
  belongs_to :institution
  ####################

  ### Methods ###
  # def correct_location_types
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  #   is_correct_type(name, String, "string", :name)
  #   is_correct_type(gps_longitude, Float, "float", :gps_longitude)
  #   is_correct_type(gps_latitude, Float, "float", :gps_latitude)
  #   is_correct_type(range, Float, "float", :range)
  # end
  #
  # def sanitize_location
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, institution_id, name, gps_longitude, gps_latitude, range, created_at, updated_at]


end
