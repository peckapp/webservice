require 'uri'

class AthleticTeam < ActiveRecord::Base
# verified
  ### team concerned in each athletic event ###
  has_many :athletic_events #

  ### home institution of each athletic team ###
  belongs_to :institution #

  URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*‌​)?$/ix
  # validates :institution_id, :presence => true, :numericality => true
  # validates :sport_name, :presence => true
  # validates :gender, :presence => true
  # validates :team_link, :format => {:with => URL_REGEX}
  
end
