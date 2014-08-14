class NotificationView < ActiveRecord::Base
  include ModelNormalValidations

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :activity_log_id, presence: true, numericality: { only_integer: true }
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validate :correct_notification_view_types

  ###############################
  ##                           ##
  ##        ASSOCIATIONS       ##
  ##                           ##
  ###############################

  # Institution
  belongs_to :institution

  ### notification is viewed by its host user ###
  belongs_to :user #

  ### notification => activity log ###
  belongs_to :activity_log #

  ###############################
  ##                           ##
  ##       HELPER METHODS      ##
  ##                           ##
  ###############################

  private

  def correct_notification_view_types
    is_correct_type(date_viewed, Time, 'datetime', :date_viewed)
  end
end
