class ActivityLog < ActiveRecord::Base

  ### Institution ###
  belongs_to :institution

  ### if activity originates from a circle ###
  belongs_to :circle #

  ### sender of activity log ###
  belongs_to :sender, :class_name => "User", :foreign_key => "sender"

  ### receiver of activity log ###
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver"

  ### activity log => notification view ###
  has_one :notification_view #

  # validates :sender, :presence => true, :numericality => true
  # validates :receiver, :presence => true, :numericality => true
  # validates :category, :presence => true
  # validates :type_of_activity, :presence => true
  # validates :message, :presence => true
  # validates :read_status, :presence => true

end
