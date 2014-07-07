class Institution < ActiveRecord::Base
# verified

  ### Validations ###
  # validates_presence_of :name
  # validates :street_address, :presence => true, :uniqueness => true
  # validates_presence_of :city
  # validates_presence_of :state
  # validates_presence_of :country
  # validates_presence_of :gps_longitude
  # validates_presence_of :gps_latitude
  # validates_presence_of :range
  # validates_presence_of :configuration_id
  # validates :api_key, :presence => true, :uniqueness => true

  ###################

  ### Callbacks ###
  #################

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

  ### caches urls where events for the institution can be found ###
  has_many :events_page_urls #

  ### rss pages to scrape
  has_many :rss_pages

  ### home institution of each circle member ###
  has_many :circle_members

  ### home institution of each subscription ###
  has_many :subscriptions

end
