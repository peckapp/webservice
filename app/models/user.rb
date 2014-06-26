class User < ActiveRecord::Base
# verified
  ########
  # each user has an encrypted secure password
  has_secure_password
  ########

  # must have authentication token
  devise :token_authenticatable

  # devise authentication
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :authentication_token, :password, :password_confirmation, :remember_me

  ### user's home institution ###
  belongs_to :institution #
  ###############################

  #### CIRCLES ###
  has_many :circles, :through => :circle_members #
  has_and_belongs_to_many :circle_members #
  ################

  ### EVENTS ###
  has_many :simple_events #
  has_and_belongs_to_many :event_attendees, :join_table => "attendees_users" #
  has_and_belongs_to_many :event_attendees, :join_table => "inviters_users" #
  ##############

  ### CLUBS ####
  belongs_to :club #
  ##############

  ### EVENT COMMENTS ###
  has_many :event_comments #
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
