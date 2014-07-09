class DiningPeriod < ActiveRecord::Base
# verified

  ### dining periods for these places ###
  belongs_to :dining_place #

  ### dining periods for these opportunities ###
  belongs_to :dining_opportunity #

  ### Institution ###
  belongs_to :institution
end
