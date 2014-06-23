class EventAttendee < ActiveRecord::Base

  ### users attending a certain event ###
  has_and_belongs_to_many :attendees, :class_name => "User", :foreign_key => "user_id"

  ### user who invited a particular attendee ###
  has_and_belongs_to_many :inviters, :class_name => "User", :foreign_key => "invited_by"
end
