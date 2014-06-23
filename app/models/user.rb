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
  has_and_belongs_to_many :event_attendees #anthoney
  has_and_belongs_to_many :event_attendees #anthoney
  ##############

  ### CLUBS ####
  belongs_to :club #
  ##############

  ### EVENT COMMENTS ###
  has_many :event_comments # anthoney. A user can have many event comments.
  ######################

  ### SUBSCRIPTIONS ###
  has_and_belongs_to_many :subscriptions #anthoney.
  #####################

  # implementation of event attendees here...

  has_one :user_device_token # anthoney

  belongs_to :event_view # anthoney

  belongs_to :notification_view # anthoney

  has_many :push_notifications # anthoney

end
