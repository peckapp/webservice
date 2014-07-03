class AthleticEvent < ActiveRecord::Base
# verified
  ### institution of event ###
  belongs_to :institution #

  ### team concerned ###
  belongs_to :athletic_team #

  # validates :institution_id, :presence => true, :numericality => true
  # validates :athletic_team_id, :presence => true, :numericality => true
  # validates :location, :presence => true

end
