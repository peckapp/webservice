# student clubs and groups at an institution
class Club < ImageContentModel
  include ModelNormalValidations

  # necessary for ImageContentModel superclass
  self.attach_file_with_root 'clubs'

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  ### club event creation ###
  has_many :simple_events #

  ### club home institution ###
  belongs_to :institution #

  ### club administrator (only one admin per club?) ###
  has_one :admin, class_name: 'User', foreign_key: 'user_id' #

  ### ANNOUNCEMENTS ###
  has_many :announcements
  #####################

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validate :institution_id, presence: true, numericality: { only_integer: true }
  validate :club_name, presence: true
  validate :user_id, numericality: { only_integer: true }, allow_nil: true
  validate :correct_club_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  private
  def correct_club_types
    is_correct_type(club_name, String, 'string', :club_name)
  end
end
