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
  validates :circle_id, :presence => true, :numericality => { :only_integer => true }
  validates :user_id, :presence => true, :numericality => { :only_integer => true }
  validates :invited_by, :presence => true, :numericality => { :only_integer => true }
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validate :correct_circle_member_types
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
  private
    def correct_circle_member_types
      is_correct_type(date_added, Time, "datetime", :date_added)
    end
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
