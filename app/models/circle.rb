class Circle < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified
  ### circle event creation ###
  has_many :simple_events #

  ### circle members ###
  has_many :users, :through => :circle_members #

  ### circle's home institution ###
  belongs_to :institution #

  ### circle's activity ###
  has_many :activity_logs #

  ### Validations ###
  validates :institution_id, :presence => true, :numericality => { :only_integer => true }
  validates :user_id, :presence => true, :numericality => { :only_integer => true }
  validates :circle_name, :presence => true
  validates :image_link, :uniqueness => true, :allow_nil => true
  validate :correct_circle_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_circle
  # before_create :sanitize_circle
  # before_update :sanitize_circle
  #################

  # Probably won't use callback
  # before_save :validate_institution_id, :validate_circle_name, :validate_user_id

  ### Methods ###
  private
  def correct_circle_types
    is_correct_type(circle_name, String, "string", :circle_name)
    is_correct_type(image_link, String, "string", :image_link)
  end
  #
  # def sanitize_circle
  #   sanitize_everything(attributes)
  # end

  # private
  #   attributes = [id, institution_id, user_id, circle_name, image_link, created_at, update_at]
  ### Probably won't use below:
  # def validate_circle_name
  #   validate_attribute(self.circle_name, "circle_name", String, "String")
  # end
end
