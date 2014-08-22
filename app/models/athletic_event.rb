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
  validates :team_score, numericality: true, allow_nil: true
  validates :opponent_score, numericality: true, allow_nil: true
  validates :home_or_away, format: { with: LETTERS_REGEX }, allow_nil: true
  validate :correct_athletic_event_types

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
    # is_correct_type(date_and_time, DateTime, 'datetime', :date_and_time)
  end
end
