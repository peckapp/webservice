class EventAttendee < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  # Institution
  belongs_to :institution

  # users attending a certain event
  belongs_to :attendee, class_name: 'User', foreign_key: 'user_id'

  # user who invited a particular attendee
  belongs_to :inviter, class_name: 'User', foreign_key: 'invited_by'

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :added_by, presence: true, numericality: { only_integer: true }
  validates :category, presence: true, format: { with: LETTERS_REGEX }
  validates :event_attended, presence: true, numericality: { only_integer: true }
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validate :correct_event_attendee_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  private
  def correct_event_attendee_types
    is_correct_type(category, String, 'string', :category)
  end
end
