class AthleticEvent < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified
  ### institution of event ###
  belongs_to :institution #

  ### team concerned ###
  belongs_to :athletic_team #

  ### Validations ###
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validates :athletic_team_id, :presence => true, :numericality => { :only_integer => true }
  validates :location, :presence => true
  validates :team_score, :numericality => true, :allow_nil => true
  validates :opponent_score, :numericality => true, :allow_nil => true
  validates :home_or_away, :format => {:with => LETTERS_REGEX}, :allow_nil => true
  validate :correct_athletic_event_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_athletic_event
  # before_create :sanitize_athletic_event
  # before_update :sanitize_athletic_event
  #################

  ### probably won't use this callback
  # before_save :validate_institution_id, :validate_athletic_team_id, :validate_location
  ###


  ### Methods ###
  private
  def correct_athletic_event_types
    is_correct_type(opponent, String, "string", :opponent)
    is_correct_type(home_or_away, String, "string", :home_or_away)
    is_correct_type(location, String, "string", :location)
    is_correct_type(result, String, "string", :result)
    is_correct_type(date_and_time, DateTime, "datetime", :date_and_time)
  end

  # def sanitize_athletic_event
  #   sanitize_everything(attributes)
  # end

  # private
  #   attributes = [id, institution_id, athletic_team_id, opponent, team_score, opponent_score, home_or_away, location, result, note, date_and_time, created_at, updated_at]

  ### Probably won't use below:
  # def validate_athletic_team_id
  #   validate_attribute(self.athletic_team_id, "athletic_team_id", Fixnum, "Fixnum")
  # end
  #
  # def validate_location
  #   validate_attribute(self.location, "location", String, "String")
  # end

end
