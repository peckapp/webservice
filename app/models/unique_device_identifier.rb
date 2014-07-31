class UniqueDeviceIdentifier < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :udid, :presence => true, :uniqueness => true


  ###############################
  ##                           ##
  ##        ASSOCIATIONS       ##
  ##                           ##
  ###############################

  ### device is associated to a particular user ###
  has_and_belongs_to_many :users

  ###############################
  ##                           ##
  ##       HELPER METHODS      ##
  ##                           ##
  ###############################

  private

    def correct_unique_device_identifier_types
      is_correct_type(udid, String, "string", :udid)
    end

end
