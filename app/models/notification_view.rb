class NotificationView < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Validations ###
  # validates :user_id, :presence => true, :numericality => true
  # validates :activity_log_id, :presence => true, :numericality => true
  # validates :viewed, :presence => true
  # validates :institution_id, :presence => true, :numericality => true
  # validate :correct_notification_view_types

  ###################

  ### Callbacks ###
  # before_save :sanitize_notification_view
  # before_create :sanitize_notification_view
  # before_update :sanitize_notification_view
  #################

  ### Associations ###
  # Institution
  belongs_to :institution

  ### notification is viewed by its host user ###
  belongs_to :user #

  ### notification => activity log ###
  belongs_to :activity_log #
  ####################

  ### Methods ###
  # def correct_notification_view_types
  #   is_correct_type(user_id, Fixnum, "fixnum", :user_id)
  #   is_correct_type(activity_log_id, Fixnum, "fixnum", :activity_log_id)
  #   is_correct_type(date_viewed, DateTime, "datetime", :date_viewed)
  #   is_correct_type(viewed, Boolean, "boolean", :viewed)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  # end

  # def sanitize_notification_view
  #   sanitize_everything(attributes)
  # end

  # private
  #   attributes = [id, user_id, activity_log_id, date_viewed, viewed, created_at, updated_at, institution_id]
end
