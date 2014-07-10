require 'uri'

class AthleticTeam < ActiveRecord::Base
  include ModelBeforeSaveValidations
# verified
  ### team concerned in each athletic event ###
  has_many :athletic_events #

  ### home institution of each athletic team ###
  belongs_to :institution #

  # validates :institution_id, :presence => true, :numericality => true
  # validates :sport_name, :presence => true
  # validates :gender, :presence => true
  # validates :team_link, :format => {:with => URL_REGEX}
  # validate :correct_athletic_team_types

  # before_save :sanitize_athletic_team
  # before_create :sanitize_athletic_team
  # before_update :sanitize_athletic_team

  ### Probably won't use callback
  # before_save :validate_institution_id

# private

  # def correct_athletic_team_types
  #   is_correct_type(sport_name, String, "string", :sport_name)
  #   is_correct_type(gender, String, "string", :gender)
  #   is_correct_type(head_coach, String, "string", :head_coach)
  #   is_correct_type(team_link, String, "string", :team_link)
  # end

  # def sanitize_athletic_team
  #   sanitize_everything([institution_id, sport_name, gender, head_coach, team_link, created_at, updated_at])
  # end
  #### Probably won't use below:
  # def validate_sport_name
  #   validate_attribute(self.sport_name, "sport", String, "String")
  # end
  #
  # def validate_gender
  #   validate_attribute(self.gender, "gender", String, "String")
  # end
  #
  # def validate_team_link
  #   error_messages = []
  #   theAttribute = self.team_link
  #   theAttribute = theAttribute.sanitize(myAttribute, tags => %w(b i u))
  #   unless theAttribute.match URL_REGEX
  #     error_messages << "Not a valid URL format"
  #   end
  #   return error_messages
  # end
end
