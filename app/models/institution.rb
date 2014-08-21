class Institution < ActiveRecord::Base
  include ModelNormalValidations

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :name, presence: true
  #validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true, format: { with: LETTERS_REGEX }
  #validates :gps_longitude, presence: true, numericality: true
  #validates :gps_latitude, presence: true, numericality: true
  #validates :range, presence: true, numericality: true
  #validates :configuration_id, presence: true, numericality: { only_integer: true }, uniqueness: true
  #validates :api_key, presence: true, uniqueness: true
  validate :correct_institution_types

  ###############################
  ##                           ##
  ##        ASSOCIATIONS       ##
  ##                           ##
  ###############################

  # home to these users
  has_many :users #

  # configuration for peck at this institution
  has_one :configuration #

  # departments at this institution
  has_many :departments #

  # all locations on campus
  has_many :locations #

  # dining places on campus
  has_many :dining_places #

  # home institution for this menu item
  has_many :menu_items #

  # home institution for each circle
  has_many :circles #

  # home institution of each athletic event
  has_many :athletic_events #

  # home institution of each athletic team
  has_many :athletic_teams #

  # home institution of each club
  has_many :clubs #

  ### home institution for each dining opportunity ###
  has_many :dining_opportunities #

  ### institution where event is taking place ###
  has_many :simple_events #

  ### caches urls where events for the institution can be found ###
  has_many :events_page_urls #

  ### ANNOUNCEMENTS ###
  has_many :announcements
  #####################

  ### other relationships ###
  has_many :activity_logs
  has_many :circle_members
  has_many :comments
  has_many :dining_periods
  has_many :event_attendees
  has_many :views
  has_many :notification_views
  # has_many :push_notifications
  has_many :subscriptions

  ### Scraping Relationships
  has_many :scrape_resources

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  private
  def correct_institution_types
    is_correct_type(name, String, 'string', :name)
    is_correct_type(street_address, String, 'string', :street_address)
    is_correct_type(city, String, 'string', :city)
    is_correct_type(state, String, 'string', :state)
    is_correct_type(country, String, 'string', :country)
    is_correct_type(api_key, String, 'string', :api_key)
  end
end
