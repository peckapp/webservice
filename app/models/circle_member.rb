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

  before_save :valid_circle_id
  before_save :valid_user_id
  before_save :valid_invited_by

  after_save :default_date_added


  def valid_circle_id
    error_messages = []
    if self.circle_id.blank?
      error_messages << "circle_id cannot be blank"
    end

    unless self.circle_id.is_a?(Fixnum)
      error_messages << "circle_id must be an integer"
    end

    puts error_messages
    return error_messages
  end

  def valid_user_id
    error_messages = []
    if self.user_id.blank?
      error_messages << "user_id cannot be blank"
    end

    unless self.user_id.is_a?(Fixnum)
      error_messages << "user_id must be an integer"
    end
    return error_messages
  end

  def valid_invited_by
    error_messages = []
    if self.invited_by.blank?
      error_messages << "invited_by cannot be blank"
    end

    unless self.invited_by.is_a?(Fixnum)
      error_messages << "invited_by must be an integer"
    end
    return error_messages
  end

  def valid_institution_id
    error_messages = []
    if self.institution_id.blank?
      error_messages << "institution_id cannot be blank"
    end

    unless self.institution_id.is_a?(Fixnum)
      error_messages << "institution_id must be an integer"
    end
    return error_messages
  end

  def default_date_added
    if date_added.blank?
      self.date_added = self.created_at
    end
  end
end
