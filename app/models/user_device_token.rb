class UserDeviceToken < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :token, :presence => true

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

    def correct_user_device_token_types
      is_correct_type(token, String, "string", :token)
    end

end
