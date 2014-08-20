class SimpleEvent < ActiveRecord::Base
  include ModelNormalValidations

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
  validates :event_url, format: { with: URI.regexp(%w(http https)) }, allow_nil: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :latitude, numericality: true, allow_nil: true
  validates :longitude, numericality: true, allow_nil: true
  validate :correct_simple_event_types

  ### Event Photo Attachments ###
  has_attached_file(:image,
                    :s3_credentials => {
                      :bucket => 'peck_development',
                      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
                    },
                    #path: ':rails_root/public/images/simple_events/:style/:basename.:extension',
                    :url => '/images/simple_events/:style/:basename.:extension',
                    :default_url => '/images/missing.png',
                    :path => 'images/simple_events/:style/:basename.:extension',
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
    is_correct_type(event_url, String, 'string', :event_url)
    is_correct_type(start_date, Time, 'datetime', :start_date)
    is_correct_type(end_date, Time, 'datetime', :end_date)
  end
end
