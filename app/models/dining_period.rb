class DiningPeriod < ActiveRecord::Base
# verified
  ### dining periods when item is available ###
  has_and_belongs_to_many :menu_items #

  ### dining periods for these places ###
  has_and_belongs_to_many :dining_places #

  ### dining periods for these opportunities ###
  has_and_belongs_to_many :dining_opportunities #
end
