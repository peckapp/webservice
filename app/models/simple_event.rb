class SimpleEvent < ImageContentModel
  include ModelNormalValidations

  # used by the scraping workers to determine model uniqueness
  CRUCIAL_ATTRS = %w(institution_id organizer_id category)
  MATCH_ATTRS = %w(title description location start_time)

  acts_as_likeable

  ###############################
  ##                           ##
  ##         VALIDATIONS       ##
  ##                           ##
  ###############################

  validates :title, presence: true, length: { maximum: 80 }
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }, allow_nil: true
  validates :organizer_id, numericality: { only_integer: true }, allow_nil: true
  validates :comment_count, numericality: { only_integer: true }, allow_nil: true
  validates :url, format: { with: URI.regexp(%w(http https)) }, allow_nil: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :latitude, numericality: true, allow_nil: true
  validates :longitude, numericality: true, allow_nil: true
  validate :correct_simple_event_types

  # if the event isn't user created, it must have a organizer with a category
  validates :organizer_id, presence: { message: 'can\'t be blank for scraped event' }, if: 'user_id.nil?'
  validates :category, presence: { message: 'can\'t be blank for scraped event' }, if: 'user_id.nil?'

  ### Event Photo Attachments ###
  # necessary for ImageContentModel superclass
  self.attach_file_with_root 'simple_events'

  ###############################
  ##                           ##
  ##        ASSOCIATIONS       ##
  ##                           ##
  ###############################

  ### user event creator ###
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id' #

  ### department event creator ###
  belongs_to :host_department, class_name: 'Department', foreign_key: 'department_id' #

  ### club event creator ###
  belongs_to :host_club, class_name: 'Club', foreign_key: 'club_id' #

  ### circle event creator ###
  belongs_to :host_circle, class_name: 'Circle', foreign_key: 'circle_id' #

  ### event's home institution ###
  belongs_to :institution #

  ### scrape resource from which this was gathered ###
  belongs_to :scrape_resource #

  ### The user who created the event (null if scraped) ###
  belongs_to :user

  ###############################
  ##                           ##
  ##           SCOPES          ##
  ##                           ##
  ###############################

  # sorts
  scope :sorted, -> { order('simple_events.start_date ASC') }

  ###############################
  ##                           ##
  ##       HELPER METHODS      ##
  ##                           ##
  ###############################

  def start_ts=(ts)
    self[:start_date] = Time.at(ts).to_datetime
  end

  def end_ts=(ts)
    self[:end_date] = Time.at(ts).to_datetime
  end

  private

  def correct_simple_event_types
    is_correct_type(title, String, 'string', :title)
    is_correct_type(url, String, 'string', :url)
    is_correct_type(start_date, Time, 'datetime', :start_date)
    is_correct_type(end_date, Time, 'datetime', :end_date)
  end
end
