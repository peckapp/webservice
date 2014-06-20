class EventMember < ActiveRecord::Base
  belongs_to :simple_event #anthoney
  belongs_to :member, :class_name => "User" #anthoney.
  belongs_to :inviter, :class_name => "User" #anthoney
end
