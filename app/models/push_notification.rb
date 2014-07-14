class PushNotification < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified
  ### Validations ###
  validates :user_id, :presence => true, :numericality => { :only_integer => true }
  validates :notification_type, :presence => true
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validate :correct_push_notification_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_push_notification
  # before_create :sanitize_push_notification
  # before_update :sanitize_push_notification
  #################

  ### Associations ###
  # Institution
  belongs_to :institution

  ### user associated to notification ###
  belongs_to :user #
  #####################

  ### Methods ###
  private
    def correct_push_notification_types
      is_correct_type(notification_type, String, "string", :notification_type)
      is_correct_type(response, String, "string", :response)
    end
  #
  # def sanitize_push_notification
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, user_id, notification_type, response, created_at, updated_at, institution_id]
end
