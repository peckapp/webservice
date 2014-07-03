class CircleMember < ActiveRecord::Base
# verified
  ### joins circles to users ###
  belongs_to :circle #
  belongs_to :member, :class_name => "User", :foreign_key => "user_id" #
  ##############################

  ### inviters of each circle member ###
  belongs_to :inviter, :class_name => "User", :foreign_key => "invited_by" #

  # validates :circle_id, :presence => true, :numericality => true
  # validates :user_id, :presence => true, :numericality => true
  # validates :invited_by, :presence => true, :numericality => true
  # validate :date_added_is_date?
  #
  # private
  #
  # def date_added_is_date?
  #   unless date_added.is_a?(Date)
  #     errors.add(:date_added, 'must be a valid date')
  #   end
  # end
end
