class PushNotification < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :user_id, :presence => true, :numericality => { :only_integer => true }
  validates :notification_type, :presence => true
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validate :correct_push_notification_types

  ###############################
  ##                           ##
  ##        ASSOCIATIONS       ##
  ##                           ##
  ###############################

  # Institution
  belongs_to :institution

  ### user associated to notification ###
  belongs_to :user #

  ###############################
  ##                           ##
  ##       HELPER METHODS      ##
  ##                           ##
  ###############################

  private
  
    def correct_push_notification_types
      is_correct_type(notification_type, String, "string", :notification_type)
      is_correct_type(response, String, "string", :response)
    end

end
