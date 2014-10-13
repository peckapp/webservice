class AthleticEvent < ImageContentModel
  include ModelNormalValidations

  # used by the scraping workers to determine model uniqueness
  CRUCIAL_ATTRS = %w(institution_id)
  MATCH_ATTRS = %w(title description athletic_team_id start_date)

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
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :team_score, numericality: true, allow_nil: true
  validates :opponent_score, numericality: true, allow_nil: true
  validates :home_or_away, format: { with: LETTERS_REGEX }, allow_nil: true
  validate :correct_athletic_event_types

  ### Event Photo Attachments ###
  # necessary for ImageContentModel superclass
  self.attach_file_with_root 'athletic_events'

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  def user_subscribed
  end

  # provides the image for the actual model, or if none exists, the image for the associated team.
  def backed_image
    image.url.match(/missing.png/) ? AthleticTeam.find(athletic_team_id).image : image
  end

  private

  def correct_athletic_event_types
    is_correct_type(opponent, String, 'string', :opponent)
    is_correct_type(home_or_away, String, 'string', :home_or_away)
    is_correct_type(location, String, 'string', :location)
    is_correct_type(result, String, 'string', :result)
    # is_correct_type(start_date, DateTime, 'datetime', :start_date)
  end
end
