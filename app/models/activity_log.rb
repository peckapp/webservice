class ActivityLog < ActiveRecord::Base

  ### if activity originates from a circle ###
  belongs_to :circle #

  ### sender of activity log ###
  belongs_to :sender, :class_name => "User", :foreign_key => "sender"

  ### receiver of activity log ###
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver"

  ### activity log => notification view ###
  has_one :notification_view #

end
