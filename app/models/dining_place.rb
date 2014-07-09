class DiningPlace < ActiveRecord::Base
# all verified
  ### home institution ###
  belongs_to :institution #

  ### host dining place of menu item ###
  has_many :menu_items #

  ### host dining place of dining period ###
  has_many :dining_periods #

  ### dining opportunities ###
  has_and_belongs_to_many :dining_opportunities, :join_table => :dining_opportunities_dining_places #
end
