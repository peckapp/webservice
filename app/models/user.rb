class User < ActiveRecord::Base

  ########
  # each user has an encrypted secure password
  has_secure_password
  ########

  ### user's home institution ###
  belongs_to :institution #
  ###############################

  #### CIRCLES ###
  has_many :circles, :through => :circle_members #
  has_and_belongs_to_many :circle_members #
  ################

  ### EVENTS ###
  has_many :simple_events #
  has_and_belongs_to_many :event_attendees ## => attendee
  # has_and_belongs_to_many :event_attendees ## => inviter
  ##############

  ### CLUBS ####
  belongs_to :club #
  ##############

  ### EVENT COMMENTS ###
  has_many :event_comments #
  ######################

  ### SUBSCRIPTIONS ###
  has_and_belongs_to_many :subscriptions #
  #####################

  ### devices on which peck is used ###
  has_and_belongs_to_many :user_device_tokens #
  #####################################

  ### user viewed a specific event ###
  belongs_to :event_view #
  ####################################

  ### ACTIVITY LOG ###
  has_many :activity_logs ## => sender
  # has_many :activity_logs ## => receiver
  ####################

  ### NOTIFICATIONS ###
  has_many :notification_views #
  has_many :push_notifications #
  #####################

end
