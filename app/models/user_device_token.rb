class UserDeviceToken < ActiveRecord::Base
# verified
  ### device is associated to a particular user ###
  has_and_belongs_to_many :users #
end
