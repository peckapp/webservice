class EventAttendee < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Associations ###
  # Institution
  belongs_to :institution

  # users attending a certain event
  belongs_to :attendee, :class_name => "User", :foreign_key => "user_id"

  # user who invited a particular attendee
  belongs_to :inviter, :class_name => "User", :foreign_key => "invited_by"
  ####################

  ### Validations ###
  validates :user_id, :presence => true, :numericality => { :only_integer => true }
  validates :added_by, :presence => true, :numericality => { :only_integer => true }
  validates :category, :presence => true, :format => {:with => LETTERS_REGEX}
  validates :event_attended, :presence => true, :numericality => { :only_integer => true }
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validate :correct_event_attendee_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_event_attendee
  # before_create :sanitize_event_attendee
  # before_update :sanitize_event_attendee
  #################

  ### Methods ###
  private
    def correct_event_attendee_types
      is_correct_type(category, String, "string", :category)
    end
  #
  # def sanitize_event_attendee
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, user_id, added_by, category, event_attended, created_at, updated_at, institution_id]
end
