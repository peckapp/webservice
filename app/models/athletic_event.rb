class AthleticEvent < ActiveRecord::Base
# verified
  ### institution of event ###
  belongs_to :institution #

  ### team concerned ###
  belongs_to :athletic_team #

  # validates :institution_id, :presence => true, :numericality => true
  # validates :athletic_team_id, :presence => true, :numericality => true
  # validates :location, :presence => true

  # before_save :validate_institution_id, :validate_athletic_team_id, :validate_location
  #private
  # def validate_athletic_team_id
  #   validate_attribute(self.athletic_team_id, "athletic_team_id", Fixnum, "Fixnum")
  # end
  #
  # def validate_location
  #   validate_attribute(self.location, "location", String, "String")
  # end

end
