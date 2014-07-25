class Announcement < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
  ###    Associations    ###
  ### user announcement creator ###
  belongs_to :creator, :class_name => "User", :foreign_key => "user_id" #

  ### department announcement creator ###
  belongs_to :host_department, :class_name => "Department", :foreign_key => "department_id" #

  ### club announcement creator ###
  belongs_to :host_club, :class_name => "Club", :foreign_key => "club_id" #

  ### circle announcement creator ###
  belongs_to :host_circle, :class_name => "Circle", :foreign_key => "circle_id" #

  ### announcement's home institution ###
  belongs_to :institution #

  ### scrape resource from which this was gathered ###
  belongs_to :scrape_resource #

  ###########################

  ###   Validations    ###
  ########################

  validates :title, :presence => true, :length => {:maximum => 80}
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validates :user_id, :numericality => { :only_integer => true }, :allow_nil => true
  validates :department_id, :numericality => { :only_integer => true }, :allow_nil => true
  validates :club_id, :numericality => { :only_integer => true }, :allow_nil => true
  validates :circle_id, :numericality => { :only_integer => true }, :allow_nil => true
  validates :comment_count, :numericality => { :only_integer => true }, :allow_nil => true
  validate :correct_announcement_types

  ### Event Photo Attachments ###
  has_attached_file :image, :url => "/images/announcements/:style/:basename.:extension", :path => ":rails_root/public/images/announcements/:style/:basename.:extension", :default_url => "/images/missing.png"
  #:styles => { :medium => "300x300>", :thumb => "100x100>" }
  # validates_attachment :image, :content_type => { :content_type => "image/jpeg"}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, :attributes => :image, :less_than => 5.megabytes


  ###   Callbacks     ###
  #######################

  private

    def correct_announcement_types
      is_correct_type(title, String, "string", :title)
    end

end
