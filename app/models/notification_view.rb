class NotificationView < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Validations ###
  validates :user_id, :presence => true, :numericality => { :only_integer => true }
  validates :activity_log_id, :presence => true, :numericality => { :only_integer => true }
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validate :correct_notification_view_types

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
  private
    def correct_notification_view_types
      is_correct_type(date_viewed, Time, "datetime", :date_viewed)
    end

  # def sanitize_notification_view
  #   sanitize_everything(attributes)
  # end

  # private
  #   attributes = [id, user_id, activity_log_id, date_viewed, viewed, created_at, updated_at, institution_id]
end
