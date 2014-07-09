class DiningOpportunity < ActiveRecord::Base
# verified
  ### home institution for this dining opportunity ###
  belongs_to :institution #

  ### opportunities for these dining periods ###
  has_many :dining_periods #

  ### dining places ###
  has_and_belongs_to_many :dining_places, :join_table => :dining_opportunities_dining_places #

  ### available menu items ###
  has_many :menu_items #
end
