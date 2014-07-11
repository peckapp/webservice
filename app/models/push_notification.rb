class PushNotification < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified
  ### Validations ###
  # validatess :user_id, :presence => true, :numericality => true
  # validates :notification_type, :presence => true
  # validates :institution_id, :presence => true, :numericality => true
  # validate :correct_push_notification_types
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
  # def correct_push_notification_types
  #   is_correct_type(user_id, Fixnum, "fixnum", :user_id)
  #   is_correct_type(notification_type, String, "string", :notification_type)
  #   is_correct_type(response, String, "string", :response)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  # end
  #
  # def sanitize_push_notification
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, user_id, notification_type, response, created_at, updated_at, institution_id]
end
