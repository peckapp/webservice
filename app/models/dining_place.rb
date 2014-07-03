class DiningPlace < ActiveRecord::Base
# all verified
  ### home institution ###
  belongs_to :institution #

  ### host dining place of menu item ###
  has_and_belongs_to_many :menu_items #

  ### host dining place of dining period ###
  has_and_belongs_to_many :dining_periods, :join_table => :dining_periods_dining_places #

  ### dining opportunities ###
  has_and_belongs_to_many :dining_opportunities #
end
