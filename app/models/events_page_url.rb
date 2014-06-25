class EventsPageUrl < ActiveRecord::Base
# verified
  ### institution where events are taking place ###
  belongs_to :institution #
end
