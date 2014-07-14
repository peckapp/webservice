class UserDeviceToken < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Callbacks ###

  #################

  ### Validations ###
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validates :token, :presence => true, :uniqueness => true
  ###################

  ### Institution ###
  belongs_to :institution

  ### device is associated to a particular user ###
  has_and_belongs_to_many :users #

  private
    def correct_user_device_token_types
      is_correct_type(token, String, "string", :token)
    end
end
