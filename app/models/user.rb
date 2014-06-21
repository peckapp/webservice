class User < ActiveRecord::Base

  ########
  # each user has an encrypted secure password
  has_secure_password
  ########

  has_many :simple_events
  belongs_to :institution
  has_many :circles, :through => :circle_members #anthoney
  has_and_belongs_to_many :circle_members
  has_one :event_member #anthoney.Member
  has_one :recipient, :class_name => "EventMember" #anthoney. Inviter. Same question as above.

end
