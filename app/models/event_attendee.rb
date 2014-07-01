class EventAttendee < ActiveRecord::Base
# verified
  ### users attending a certain event ###
  belongs_to :attendee, :class_name => "User", :foreign_key => "user_id"

  ### user who invited a particular attendee ###
  belongs_to :inviter, :class_name => "User", :foreign_key => "invited_by"
end
