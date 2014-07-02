class DiningPeriod < ActiveRecord::Base
# verified
  ### dining periods when item is available ###
  has_and_belongs_to_many :menu_items #

  ### dining periods for these places ###
  has_and_belongs_to_many :dining_places, :join_table => :dining_periods_dining_places #

  ### dining periods for these opportunities ###
  belongs_to :dining_opportunity #
end
