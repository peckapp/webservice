class UdidUser < ActiveRecord::Base
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

belongs_to :user
belongs_to :unique_device_identifier

###############################
##                           ##
##       HELPER METHODS      ##
##                           ##
###############################

private

end
