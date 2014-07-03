class User < ActiveRecord::Base
# verified
  ########
  # each user has an encrypted secure password
  # has_secure_password
  ########

  #### Callbacks #######

  ######################

  #### Validations ###############
  # validates_presence_of :institution_id
  # validates_presence_of :first_name
  # validates_presence_of :last_name
  # validates :username, :presence => true, :uniqueness => true
  # validates :api_key, :presence => true, :uniqueness => true
  ###############################

  ### user's home institution ###
  belongs_to :institution #
  ###############################

  #### CIRCLES ###
  has_many :circles, :through => :circle_members #
  has_many :circle_members #
  ################

  ### EVENTS ###
  has_many :simple_events #
  has_many :event_attendees #
  has_many :event_attendees_as_inviters, :class_name => "EventAttendee" #
  ##############

  ### CLUBS ####
  belongs_to :club #
  ##############

  ### EVENT COMMENTS ###
  has_many :comments #
  ######################

  ### SUBSCRIPTIONS ###
  has_many :subscriptions #
  #####################

  ### devices on which peck is used ###
  has_and_belongs_to_many :user_device_tokens #
  #####################################

  ### user viewed a specific event ###
  belongs_to :event_view #
  ####################################

  ### ACTIVITY LOG ###
  has_many :activity_logs_sent, :class_name => "ActivityLog" #
  has_many :activity_logs_received, :class_name => "ActivityLog" #
  ####################

  ### NOTIFICATIONS ###
  has_many :notification_views #
  has_many :push_notifications #
  #####################

end
