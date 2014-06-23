class EventComment < ActiveRecord::Base
  # need to see whether it's a simple or athletic event. have not implemented
  belongs_to :user # anthoney. belongs to user who comments.
end
