class Institution < ActiveRecord::Base

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

  ###
  has_many :athletic_events # anthoney. an institution has many athletic events.

  ###
  has_many :athletic_teams # anthoney. an institution has many athletic teams.

  ###
  has_many :clubs # anthoney. an institution has many clubs.

  ### home institution for each dining opportunity ###
  has_many :dining_opportunities #

  ###
  has_many :simple_events

end
