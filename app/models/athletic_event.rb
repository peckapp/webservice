class AthleticEvent < ActiveRecord::Base
# verified
  ### institution of event ###
  belongs_to :institution #

  ### team concerned ###
  belongs_to :athletic_team #
end
