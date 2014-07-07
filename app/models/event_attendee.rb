class EventAttendee < ActiveRecord::Base
# verified

  ### Institution ###
  belongs_to :institution
  
  ### users attending a certain event ###
  belongs_to :attendee, :class_name => "User", :foreign_key => "user_id"

  ### user who invited a particular attendee ###
  belongs_to :inviter, :class_name => "User", :foreign_key => "invited_by"
end
