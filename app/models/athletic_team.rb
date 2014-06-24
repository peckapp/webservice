class AthleticTeam < ActiveRecord::Base
# verified
  ### team concerned in each athletic event ###
  has_many :athletic_events #

  ### home institution of each athletic team ###
  belongs_to :institution #
end
