# academic departments at an institution
class Department < ImageContentModel
  include ModelNormalValidations

  # necessary for ImageContentModel superclass
  self.has_attached_file_with_root 'departments'

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  # department event creation
  has_many :simple_events

  # department's home institution
  belongs_to :institution

  ### ANNOUNCEMENTS ###
  has_many :announcements
  #####################

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :name, presence: true
  validates :institution_id, presence: true, numericality: { only_integer: true }
  validate :correct_department_types

  # for active admin
  def display_name
    name
  end

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  private
  def correct_department_types
    is_correct_type(name, String, 'string', :name)
  end
end
