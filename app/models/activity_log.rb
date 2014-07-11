class ActivityLog < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
  ### Institution ###
  belongs_to :institution

  ### if activity originates from a circle ###
  belongs_to :circle #

  ### messenger of activity log ###
  belongs_to :messenger, :class_name => "User", :foreign_key => "sender"

  ### recipient of activity log ###
  belongs_to :recipient, :class_name => "User", :foreign_key => "receiver"

  ### activity log => notification view ###
  has_one :notification_view #

  ### Validations ###
  # validates :sender, :presence => true, :numericality => true
  # validates :receiver, :presence => true, :numericality => true
  # validates :category, :presence => true, :format => { :with => LETTERS_REGEX }
  # validates :from_event, :numericality => true, :allow_nil => true
  # validates :circle_id, :numericality => true, :allow_nil => true
  # validates :type_of_activity, :presence => true, :format => { :with => LETTERS_REGEX }
  # validates :message, :presence => true
  # validates :read_status, :presence => true
  # validates :institution_id, :presence => true, :numericality => true
  # validate :correct_activity_log_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_activity_log
  # before_create :sanitize_activity_log
  # before_update :sanitize_activity_log
  #################

  ### Probably won't use this callback
  # before_save :validate_messenger, :validate_recipient, :validate_institution_id, :validate_message, :validate_read_status, :validate_category, :validate_type_of_activity

  ### Methods ###
  # def correct_activity_log_types
  #   is_correct_type(sender, Fixnum, "fixnum", :sender)
  #   is_correct_type(receiver, Fixnum, "fixnum", :receiver)
  #   is_correct_type(category, String, "string", :category)
  #   is_correct_type(from_event, Fixnum, "fixnum", :from_event)
  #   is_correct_type(circle_id, Fixnum, "fixnum", :circle_id)
  #   is_correct_type(type_of_activity, String, "string", :type_of_activity)
  #   is_correct_type(message, String, "string", :message)
  #   is_correct_type(read_status, Boolean, "boolean", :read_status)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  # end
  #
  # def sanitize_activity_log
  #   sanitize_everything(attributes)
  # end

  # private
  #   attributes = [id, sender, receiver, category, from_event, circle_id, type_of_activity, message, read_status, created_at, updated_at, institution_id]

  #### Probably won't use everything below:
  # def validate_message
  #   validate_attribute(self.message, "message", String, "String")
  # end
  #
  # def validate_messenger
  #   validate_attribute(self.sender, "messenger", Fixnum, "Fixnum")
  # end
  #
  # def validate_read_status
  #   validate_attribute(self.read_status, "read_status", Boolean, "Boolean")
  # end
  #
  # def validate_recipient
  #   validate_attribute(self.receiver, "recipient", Fixnum, "Fixnum")
  # end
  #
  # def validate_type_of_activity
  #   validate_attribute(self.type_of_activity, "type_of_activity", String, "String")
  # end
end
