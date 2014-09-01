# athletic teams that athletic event subscriptions belong to
class AthleticTeam < ImageContentModel
  include ModelNormalValidations

  # necessary for ImageContentModel superclass
  self.has_attached_file_with_root 'athletic_teams'

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
