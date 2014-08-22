class Peck < ActiveRecord::Base
  include ModelNormalValidations

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :notification_type, presence: true
  validates :notification_type, inclusion: { in: %w(circle_invite circle_comment event_invite event_comment), message: '%{value} is not an available type' }
  validates :invitation, numericality: { only_integer: true }, allow_nil: true
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validate :correct_peck_types

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

  def correct_peck_types
    is_correct_type(notification_type, String, 'string', :notification_type)
    is_correct_type(message, String, 'string', :message)
  end
end
