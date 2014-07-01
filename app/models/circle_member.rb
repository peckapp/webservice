class CircleMember < ActiveRecord::Base
# verified
  ### joins circles to users ###
  belongs_to :circle #
  belongs_to :member, :class_name => "User", :foreign_key => "user_id" #
  ##############################

  ### inviters of each circle member ###
  belongs_to :inviter, :class_name => "User", :foreign_key => "invited_by" #
end
