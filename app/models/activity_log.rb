class ActivityLog < ActiveRecord::Base

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

  # validates :messenger, :presence => true, :numericality => true
  # validates :receipient, :presence => true, :numericality => true
  # validates :category, :presence => true
  # validates :type_of_activity, :presence => true
  # validates :message, :presence => true
  # validates :read_status, :presence => true
  # before save :validate_user_id, :validate_institution_id, :validate_message, :validate_read_status, :validate_category, :validate_type_of_activity

  # private
  def validate_message
  end

  def validate_read_status
  end

  def validate_type_of_activity
  end
end
