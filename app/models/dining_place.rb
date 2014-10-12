# locations on campus where dining opportunties occur
class DiningPlace < ImageContentModel
  include ModelNormalValidations

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  # home institution
  belongs_to :institution #

  # host dining place of menu item
  has_many :menu_items #

  # host dining place of dining period
  has_many :dining_periods #

  # dining opportunities #
  has_and_belongs_to_many :dining_opportunities, join_table: :dining_opportunities_dining_places #

  ### Event Photo Attachments ###
  # necessary for ImageContentModel superclass
  self.attach_file_with_root 'dining_places'

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :institution_id, presence: true, numericality: { only_integer: true }
  validates :name, presence: true
  validates :gps_longitude, numericality: true, allow_nil: true
  validates :gps_latitude, numericality: true, allow_nil: true
  validates :range, numericality: true, allow_nil: true
  validate :correct_dining_place_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  private

  def correct_dining_place_types
    is_correct_type(name, String, 'string', :name)
    is_correct_type(details_link, String, 'string', :details_link)
  end
end
