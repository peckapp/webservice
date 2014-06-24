class EventView < ActiveRecord::Base
# verified
  ### user who viewed the event ###
  has_many :users #
end
