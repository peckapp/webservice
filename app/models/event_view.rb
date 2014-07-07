class EventView < ActiveRecord::Base
# verified

  ### Institution ###
  belongs_to :institution
  
  ### user who viewed the event ###
  has_many :users #
end
