class EventMember < ActiveRecord::Base
  belongs_to :simple_event #anthoney
  belongs_to :member, :class_name => "User", :foreign_key => "user_id" #anthoney.
  has_and_belongs_to_many :inviters, :class_name => "User", :foreign_key => "user_id" #anthoney
end
