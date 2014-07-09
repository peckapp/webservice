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

  before_save :validate_institution_id,

# private 
  def validate_sport_name
    validate_attribute(self.sport_name, "sport", String, "String")
  end

  def validate_gender
    validate_attribute(self.gender, "gender", String, "String")
  end

  def validate_team_link
    error_messages = []
    theAttribute = self.team_link
    theAttribute = theAttribute.sanitize(myAttribute, tags => %w(b i u))
    unless theAttribute.match URL_REGEX
      error_messages << "Not a valid URL format"
    end
    return error_messages
  end
end
