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
  # validates :user_id, :presence => true, :numericality => true
  # validates :added_by, :presence => true, :numericality => true
  # validates :category, :presence => true, :format => {:with => LETTERS_REGEX}
  # validates :event_attended, :presence => true, :numericality => true
  # validates :institution_id, :presence => true, :numericality => true
  # validate :correct_event_attendee_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_event_attendee
  # before_create :sanitize_event_attendee
  # before_update :sanitize_event_attendee
  #################

  ### Methods ###
  # def correct_event_attendee_types
  #   is_correct_type(user_id, Fixnum, "fixnum", :user_id)
  #   is_correct_type(added_by, Fixnum, "fixnum", :added_by)
  #   is_correct_type(category, String, "string", :category)
  #   is_correct_type(event_attended, Fixnum, "fixnum", :event_attended)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  # end
  #
  # def sanitize_event_attendee
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, user_id, added_by, category, event_attended, created_at, updated_at, institution_id]
end
