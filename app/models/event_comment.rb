class EventComment < ActiveRecord::Base
# verified
  ### author of comment ###
  belongs_to :user #
end
