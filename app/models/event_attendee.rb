class EventAttendee < ActiveRecord::Base
  has_and_belongs_to_many :attendees, :class_name => "User", :foreign_key => "user_id"
  has_and_belongs_to_many :inviters, :class_name => "User", :foreign_key => "invited_by"
end
