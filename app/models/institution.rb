class Institution < ActiveRecord::Base
# verified
  ### home to these users ###
  has_many :users #

  ### configuration for peck at this institution ###
  has_one :configuration #

  ### departments at this institution ###
  has_many :departments #

  ### all locations on campus ###
  has_many :locations #

  ### dining places on campus ###
  has_many :dining_places #

  ### home institution for this menu item ###
  has_many :menu_items #

  ### home institution for each circle ###
  has_many :circles #

  ### home institution of each athletic event ###
  has_many :athletic_events #

  ### home institution of each athletic team ###
  has_many :athletic_teams #

  ### home institution of each club ###
  has_many :clubs #

  ### home institution for each dining opportunity ###
  has_many :dining_opportunities #

  ### institution where event is taking place ###
  has_many :simple_events #

end