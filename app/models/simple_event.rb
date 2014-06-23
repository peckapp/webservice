class SimpleEvent < ActiveRecord::Base
# all verified
  ### user event creator ###
  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"

  ### department event creator ###
  belongs_to :host_department, :class_name => "Department", :foreign_key => "department_id"

  ### club event creator ###
  belongs_to :host_club, :class_name => "Club", :foreign_key => "club_id"

  ### circle event creator ###
  belongs_to :host_circle, :class_name => "Circle", :foreign_key => "circle_id"

  ### event's home institution ###
  belongs_to :institution

end
