class EventAttendee < ActiveRecord::Base
# verified
  ### users attending a certain event ###
  has_and_belongs_to_many :attendees, :class_name => "User", :foreign_key => "user_id", :join_table => "attendees_users"

  ### user who invited a particular attendee ###
  has_and_belongs_to_many :inviters, :class_name => "User", :foreign_key => "invited_by", :join_table => "inviters_users"
end
