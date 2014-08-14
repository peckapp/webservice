class UdidUser < ActiveRecord::Base
include ModelNormalValidations

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

belongs_to :user
belongs_to :unique_device_identifier

###############################
##                           ##
##       HELPER METHODS      ##
##                           ##
###############################
scope :sorted, -> { order('udid_users.updated_at ASC') }
private

end
