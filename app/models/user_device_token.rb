class UserDeviceToken < ActiveRecord::Base
# verified

  ### Callbacks ###

  #################

  ### Validations ###
  # validates :user_id, :presence => true
  # validates :token, :presence => true, :uniqueness => true
  ###################

  ### Institution ###
  belongs_to :institution

  ### device is associated to a particular user ###
  has_and_belongs_to_many :users #
end
