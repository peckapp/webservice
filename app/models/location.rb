class Location < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :institution_id, presence: true, numericality: { only_integer: true }
  validates :name, presence: true
  validates :gps_longitude, numericality: true, allow_nil: true
  validates :gps_latitude, numericality: true, allow_nil: true
  validates :range, numericality: true, allow_nil: true
  validate :correct_location_types

  ###############################
  ##                           ##
  ##        ASSOCIATIONS       ##
  ##                           ##
  ###############################

  ### a location has just one institution ###
  belongs_to :institution

  ###############################
  ##                           ##
  ##       HELPER METHODS      ##
  ##                           ##
  ###############################

  private
  def correct_location_types
    is_correct_type(name, String, 'string', :name)
  end
end
