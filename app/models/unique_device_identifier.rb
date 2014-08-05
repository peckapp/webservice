class UniqueDeviceIdentifier < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################


  # validates :udid, :presence => true


  ###############################
  ##                           ##
  ##        ASSOCIATIONS       ##
  ##                           ##
  ###############################

  ### device is associated to a particular user ###
  has_many :udid_users
  has_many :users, through: :udid_users

  ###############################
  ##                           ##
  ##       HELPER METHODS      ##
  ##                           ##
  ###############################

  private

  def correct_unique_device_identifier_types
    is_correct_type(udid, String, 'string', :udid)
  end
end
