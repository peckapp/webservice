class MenuItem < ActiveRecord::Base
# verified
  ### institution where item is available ###
  belongs_to :institution #

  ### dining place where item is available ###
  has_and_belongs_to_many :dining_places #

  ### menu item is available during these periods ###
  has_and_belongs_to_many :dining_periods #
end
