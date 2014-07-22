class SimpleEvent < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# all verified

  ### Validations ###
  validates :title, :presence => true, :length => {:maximum => 80}
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validates :user_id, :numericality => { :only_integer => true }, :allow_nil => true
  validates :department_id, :numericality => { :only_integer => true }, :allow_nil => true
  validates :club_id, :numericality => { :only_integer => true }, :allow_nil => true
  validates :circle_id, :numericality => { :only_integer => true }, :allow_nil => true
  validates :comment_count, :numericality => { :only_integer => true }, :allow_nil => true
  validates :event_url, :format => {:with => URI::regexp(%w(http https))}, :allow_nil => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :latitude, :numericality => true, :allow_nil => true
  validates :longitude, :numericality => true, :allow_nil => true
  validate :correct_simple_event_types
  ####################

  ### Event Photo Attachments ###
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, :attributes => :image, :less_than => 2.megabytes
  ####################

  ### Associations ###

  ### user event creator ###
  belongs_to :creator, :class_name => "User", :foreign_key => "user_id" #

  ### department event creator ###
  belongs_to :host_department, :class_name => "Department", :foreign_key => "department_id" #

  ### club event creator ###
  belongs_to :host_club, :class_name => "Club", :foreign_key => "club_id" #

  ### circle event creator ###
  belongs_to :host_circle, :class_name => "Circle", :foreign_key => "circle_id" #

  ### event's home institution ###
  belongs_to :institution #

  ### scrape resource from which this was gathered ###
  belongs_to :scrape_resource #

  #####################

  ### Scopes ###
  # sorts
  scope :sorted, lambda {order("simple_events.start_date ASC")}
  #scope :explore, lambda {select("*")}

  ### Methods ###
  private
    def correct_simple_event_types
      is_correct_type(title, String, "string", :title)
      is_correct_type(event_url, String, "string", :event_url)
      is_correct_type(image_url, String, "string", :image_url)
      is_correct_type(start_date, Time, "datetime", :start_date)
      is_correct_type(end_date, Time, "datetime", :end_date)
    end
  #
  # def sanitize_simple_event
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, title, event_description, institution_id, user_id, department_id, club_id, circle_id, event_url, open, image_url, comment_count, start_date, end_date, deleted, created_at, updated_at, latitude, longitude]
end
