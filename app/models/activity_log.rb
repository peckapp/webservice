class ActivityLog < ActiveRecord::Base
  include ModelNormalValidations

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  ### Institution ###
  belongs_to :institution

  ### if activity originates from a circle ###
  belongs_to :circle #

  ### messenger of activity log ###
  belongs_to :messenger, class_name: 'User', foreign_key: 'sender'

  ### recipient of activity log ###
  belongs_to :recipient, class_name: 'User', foreign_key: 'receiver'

  ### activity log => notification view ###
  has_one :notification_view #

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :sender, presence: true, numericality: { only_integer: true }
  validates :receiver, presence: true, numericality: { only_integer: true }
  validates :category, presence: true, format: { with: LETTERS_REGEX }
  validates :from_event, numericality: { only_integer: true }, allow_nil: true
  validates :circle_id, numericality: { only_integer: true }, allow_nil: true
  validates :type_of_activity, presence: true, format: { with: LETTERS_REGEX }
  validates :message, presence: true
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validate :correct_activity_log_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  private
  def correct_activity_log_types
    is_correct_type(category, String, 'string', :category)
    is_correct_type(type_of_activity, String, 'string', :type_of_activity)
    is_correct_type(message, String, 'string', :message)
  end
end
