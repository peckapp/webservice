class SimpleEvent < ActiveRecord::Base
  include ModelNormalValidations

  # used by the scraping workers to determine model uniqueness
  CRUCIAL_ATTRS = %w(title institution_id start_date)

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
  has_attached_file(:image,
                    s3_credentials: {
                      bucket: ENV['AWS_BUCKET_NAME'],
                      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
                    },
                    # path: ':rails_root/public/images/simple_events/:style/:basename.:extension',
                    url: '/images/simple_events/:style/:basename.:extension',
                    default_url: '/images/missing.png',
                    path: 'images/simple_events/:style/:basename.:extension',
                    styles: {
                      detail: '100X100#',
                      blurred: {
                        size: '640x256',
                        offset: '+0+0',
                        raduis_sigma: '9x4',
                        tint: '40',
                        processors: [:blur]
                      }
                    })

  # validates_attachment :image, :content_type => { :content_type => "image/jpeg"}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 5.megabytes

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
