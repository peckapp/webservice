class AthleticEvent < ActiveRecord::Base
  include ModelNormalValidations

  acts_as_likeable

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  belongs_to :institution #

  ### team concerned ###
  belongs_to :athletic_team #

  ### scrape resource from which this was gathered ###
  belongs_to :scrape_resource #

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :institution_id, presence: true, numericality: { only_integer: true }
  validates :athletic_team_id, presence: true, numericality: { only_integer: true }
  validates :location, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :team_score, numericality: true, allow_nil: true
  validates :opponent_score, numericality: true, allow_nil: true
  validates :home_or_away, format: { with: LETTERS_REGEX }, allow_nil: true
  validate :correct_athletic_event_types

  ### Event Photo Attachments ###
  # basically identical to simple_events, should consolidate these options for the homepage into one place if possible
  has_attached_file(:image,
                    s3_credentials: {
                      bucket: 'peck_development',
                      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
                    },
                    # path: ':rails_root/public/images/simple_events/:style/:basename.:extension',
                    url: '/images/athletic_events/:style/:basename.:extension',
                    default_url: '/images/missing.png',
                    path: 'images/athletic_events/:style/:basename.:extension',
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
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  private
  def correct_athletic_event_types
    is_correct_type(opponent, String, 'string', :opponent)
    is_correct_type(home_or_away, String, 'string', :home_or_away)
    is_correct_type(location, String, 'string', :location)
    is_correct_type(result, String, 'string', :result)
    # is_correct_type(start_time, DateTime, 'datetime', :start_time)
  end
end
