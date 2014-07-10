class CircleMember < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Associations ###

  #Institution
  belongs_to :institution

  ### joins circles to users ###
  belongs_to :circle #
  belongs_to :member, :class_name => "User", :foreign_key => "user_id" #
  ##############################

  ### inviters of each circle member ###
  belongs_to :inviter, :class_name => "User", :foreign_key => "invited_by" #

  belongs_to :institution

  ####################

  ### Validations ###
#   validates :circle_id, :presence => true, :numericality => true
#   validates :user_id, :presence => true, :numericality => true
#   validates :invited_by, :presence => true, :numericality => true
#   validates :institution_id, :presence => true, :numericality => true
#   validate :correct_circle_member_types
 #####################

 ### Callbacks ###
#   before_save :sanitize_circle_member
#   before_create :sanitize_circle_member
#   before_update :sanitize_circle_member
#   after_save :default_date_added
##################

#   #### Probably won't use following callback
#   before_save :validate_circle_id, :validate_user_id, :validate_invited_by, :validate_institution_id

  ### Methods ###
  # def correct_circle_member_types
  #   is_correct_type(circle_id, Fixnum, "fixnum", :circle_id)
  #   is_correct_type(user_id, Fixnum, "fixnum", :user_id)
  #   is_correct_type(invited_by, Fixnum, "fixnum", :invited_by)
  #   is_correct_type(date_added, DateTime, "datetime", :date_added)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  # end
#   def sanitize_circle_member
#     sanitize_everything(attributes)
#   end
###### Probably won't use below:
#   def validate_invited_by
#     validate_attribute(self.invited_by, "invited by", Fixnum, "Fixnum")
#   end

# private
#   attributes = [id, circle_id, user_id, invited_by, date_added, created_at, updated_at, institution_id]
#   def default_date_added
#     if date_added.blank?
#       self.date_added = self.created_at
#     end
#   end
end
