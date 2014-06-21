class CircleMember < ActiveRecord::Base
  belongs_to :circle
  belongs_to :member, :class_name => "User", :foreign_key => "user_id"
  has_and_belongs_to_many :inviters, :class_name => "User", :foreign_key => "invited_by"
end
