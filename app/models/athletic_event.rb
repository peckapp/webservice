class AthleticEvent < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified
  ### institution of event ###
  belongs_to :institution #

  ### team concerned ###
  belongs_to :athletic_team #

  # validates :institution_id, :presence => true, :numericality => true
  # validates :athletic_team_id, :presence => true, :numericality => true
  # validates :location, :presence => true
  # validate :correct_athletic_event_types

  # before_save :sanitize_athletic_event
  # before_create 

  ### probably won't use this callback
  # before_save :validate_institution_id, :validate_athletic_team_id, :validate_location
  ###

  #private
  #
  # def
  #
  # end
  #
  #
  # def correct_athletic_event_types
  #   is_correct_type(opponent, String, "string", :opponent)
  #   is_correct_type(home_or_away, String, "string", :home_or_away)
  #   is_correct_type(location, String, "string", :location)
  #   is_correct_type(result, String, "string", :result)
  #   is_correct_type(team_score, Float, "float", :team_score)
  #   is_correct_type(opponent_score, Float, "float", :opponent_score)
  #   is_correct_type(date_and_time, DateTime, "datetime", :date_and_time)
  # end

  # def sanitize_athletic_event
  #   sanitize_everything([institution_id, athletic_team_id, opponent, team_score, opponent_score, home_or_away, location, result, note, date_and_time, created_at, updated_at])
  # end

  ### Probably won't use below:
  # def validate_athletic_team_id
  #   validate_attribute(self.athletic_team_id, "athletic_team_id", Fixnum, "Fixnum")
  # end
  #
  # def validate_location
  #   validate_attribute(self.location, "location", String, "String")
  # end

end
