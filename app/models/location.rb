class Location < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Validations ###
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validates :name, :presence => true
  validates :gps_longitude, :numericality => true, :allow_nil => true
  validates :gps_latitude, :numericality => true, :allow_nil => true
  validates :range, :numericality => true, :allow_nil => true
  validate :correct_location_types
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
  private
    def correct_location_types
      is_correct_type(name, String, "string", :name)
    end
  #
  # def sanitize_location
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, institution_id, name, gps_longitude, gps_latitude, range, created_at, updated_at]


end
