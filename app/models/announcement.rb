# text-based announcements of information with possible photo attachements
class Announcement < ActiveRecord::Base
  # used by the scraping workers to determine model uniqueness
  CRUCIAL_ATTRS = %w(institution_id)
  MATCH_ATTRS = %w(title announcement_description category)

  include ModelNormalValidations
  ###    Associations    ###
  ### user announcement creator ###
  acts_as_likeable

  belongs_to :creator, class_name: 'User', foreign_key: 'user_id' #

  ### department announcement creator ###
  belongs_to :host_department, class_name: 'Department', foreign_key: 'department_id' #

  ### club announcement creator ###
  belongs_to :host_club, class_name: 'Club', foreign_key: 'club_id' #

  ### circle announcement creator ###
  belongs_to :host_circle, class_name: 'Circle', foreign_key: 'circle_id' #

  ### announcement's home institution ###
  belongs_to :institution #

  ### scrape resource from which this was gathered ###
  belongs_to :scrape_resource #

  ###########################

  ###   Validations    ###
  ########################

  validates :title, presence: true, length: { maximum: 80 }
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }, allow_nil: true
  validates :poster_id, numericality: { only_integer: true }, allow_nil: true
  validates :comment_count, numericality: { only_integer: true }, allow_nil: true
  validate :correct_announcement_types

  ### Event Photo Attachments ###
  has_attached_file(:image,
                    s3_credentials: {
                      bucket: ENV['AWS_BUCKET_NAME'],
                      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
                    },
                    url: '/images/announcements/:style/:basename.:extension',
                    path: 'images/announcements/:style/:basename.:extension',
                    default_url: '/images/missing.png',
                    styles: { medium: '300x300>', thumb: '100x100>' })

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 5.megabytes

  ###   Callbacks     ###
  #######################

  ### Scopes ###
  scope :sorted, lambda { order('announcements.created_at DESC') }
  ##############

  private

  def correct_announcement_types
    is_correct_type(title, String, 'string', :title)
  end
end
