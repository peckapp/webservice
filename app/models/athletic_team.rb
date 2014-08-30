# athletic teams that athletic event subscriptions belong to
class AthleticTeam < ImageContentModel
  include ModelNormalValidations

  @image_path_root = 'athletic_teams'

  # should be handled by image content module...
  # has_attached_file(:image,
  #                   s3_credentials: {
  #                     bucket: ENV['AWS_BUCKET_NAME'],
  #                     access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  #                     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  #                   },
  #                   # path: ':rails_root/public/images/simple_events/:style/:basename.:extension',
  #                   url: "/images/#{@image_path_root}/:style/:basename.:extension",
  #                   default_url: '/images/missing.png',
  #                   path: "images/#{@image_path_root}/:style/:basename.:extension",
  #                   styles: {
  #                     detail: '100X100#',
  #                     blurred: {
  #                       size: '640x256',
  #                       offset: '+0+0',
  #                       raduis_sigma: '9x4',
  #                       tint: '40',
  #                       processors: [:blur]
  #                     }
  #                   })

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  ### team concerned in each athletic event ###
  has_many :athletic_events #

  ### home institution of each athletic team ###
  belongs_to :institution #

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :institution_id, presence: true, numericality: { only_integer: true }
  validates :sport_name, presence: true
  validates :gender, presence: true, format: { with: LETTERS_REGEX }
  validates :team_link, format: { with: URI.regexp(%w(http https)) }, uniqueness: true, allow_nil: true
  validates :head_coach, format: { with: LETTERS_REGEX }, allow_nil: true
  validate :correct_athletic_team_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  # for active admin
  def display_name
    "#{Institution.find(institution_id).name} #{gender}'s #{sport_name}"
  end

  private

  def correct_athletic_team_types
    is_correct_type(sport_name, String, 'string', :sport_name)
    is_correct_type(gender, String, 'string', :gender)
    is_correct_type(team_link, String, 'string', :team_link)
    is_correct_type(head_coach, String, 'string', :head_coach)
  end
end
