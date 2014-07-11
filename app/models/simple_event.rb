class SimpleEvent < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# all verified

  ### Validations ###
  # validates :title, :presence => true, :length => {:maximum => 80}
  # validates :institution_id, :presence => true, :numericality => true
  # validates :user_id, :numericality => true, :allow_nil => true
  # validates :department_id, :numericality => true, :allow_nil => true
  # validates :club_id, :numericality => true, :allow_nil => true
  # validates :circle_id, :numericality => true, :allow_nil => true
  # validates :event_url, :format => {:with => URL_REGEX}
  # validates :start_date, :presence => true
  # validates :end_date, :presence => true
  # validates :latitude, :numericality => true, :allow_nil => true
  # validates :longitude, :numericality => true, :allow_nil => true
  # validate :correct_simple_event_types
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

  #####################

  ### Scopes ###
  # sorts
  scope :sorted, lambda {order("simple_events.start_date ASC")}
  #scope :explore, lambda {select("*")}

  ### Methods ###
  # def correct_simple_event_types
  #   is_correct_type(title, String, "string", :title)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  #   is_correct_type(user_id, Fixnum, "fixnum", :user_id)
  #   is_correct_type(department_id, Fixnum, "fixnum", :department_id)
  #   is_correct_type(club_id, Fixnum, "fixnum", :club_id)
  #   is_correct_type(circle_id, Fixnum, "fixnum", :circle_id)
  #   is_correct_type(event_url, String, "string", :event_url)
  #   is_correct_type(open, Boolean, "boolean", :open)
  #   is_correct_type(image_url, String, "string", :image_url)
  #   is_correct_type(comment_count, Fixnum, "fixnum", :comment_count)
  #   is_correct_type(start_date, DateTime, "datetime", :start_date)
  #   is_correct_type(end_date, DateTime, "datetime", :end_date)
  #   is_correct_type(deleted, Boolean, "boolean", :deleted)
  #   is_correct_type(latitude, Float, "float", :latitude)
  #   is_correct_type(longitude, Float, "float", :longitude)
  # end
  #
  # def sanitize_simple_event
  #   sanitize_everything(attributes)
  # end
  #
  # private
  #   attributes = [id, title, event_description, institution_id, user_id, department_id, club_id, circle_id, event_url, open, image_url, comment_count, start_date, end_date, deleted, created_at, updated_at, latitude, longitude]
end
