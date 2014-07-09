class CircleMember < ActiveRecord::Base
# verified

  ### Institution ###
  belongs_to :institution

  ### joins circles to users ###
  belongs_to :circle #
  belongs_to :member, :class_name => "User", :foreign_key => "user_id" #
  ##############################

  ### inviters of each circle member ###
  belongs_to :inviter, :class_name => "User", :foreign_key => "invited_by" #

  belongs_to :institution

  ### Redundant checks ###
  validates :circle_id, :presence => true, :numericality => true
  validates :user_id, :presence => true, :numericality => true
  validates :invited_by, :presence => true, :numericality => true

  before_save :validate_circle_id, :validate_user_id, :validate_invited_by, :validate_institution_id

  after_save :default_date_added

# private
  def validate_invited_by
    validate_attribute(self.invited_by, "invited by", Fixnum, "Fixnum")
  end

  def default_date_added
    if date_added.blank?
      self.date_added = self.created_at
    end
  end
end
