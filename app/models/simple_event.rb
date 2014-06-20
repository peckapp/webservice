class SimpleEvent < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :host_department, :class_name => "Department"
  belongs_to :host_club, :class_name => "Club"
  belongs_to :host_circle, :class_name => "Circle"

end
