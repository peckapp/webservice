class User < ActiveRecord::Base

  ########
  # each user has an encrypted secure password
  has_secure_password
  ########


  belongs_to :institution
  has_many :circles, :through => :circle_members #anthoney
  has_and_belongs_to_many :circle_members

  has_many :simple_events, :through => :event_members # anthoney
  has_and_belongs_to_many :event_members #anthoney


  belongs_to :club #anthoney. Admin belongs to the club.
  has_many :event_comments # anthoney. A user can have many event comments.

  has_and_belongs_to_many :subscriptions #anthoney.

  # implementation of event attendees here...

  has_one :user_device_token # anthoney

  belongs_to :event_view # anthoney

  belongs_to :notification_view # anthoney

  has_many :push_notifications # anthoney

end
