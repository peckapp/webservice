class Department < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# all verified

  ### Associations ###
  # department event creation
  has_many :simple_events

  # department's home institution
  belongs_to :institution
  ####################

  ### Validations ###
  # validates :name, :presence => true
  # validates :institution_id, :presence => true, :numericality => true
  # validate :correct_department_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_department
  # before_create :sanitize_department
  # before_update :sanitize_department
  #################

  ### Methods ###
  # def correct_department_types
  #   is_correct_type(name, String, "string", :name)
  #   is_correct_type(institution_id, Fixnum, "fixnum", :institution_id)
  # end
  #
  # def sanitize_department
  #   sanitize_everything(attributes)
  # end

  # private
  #   attributes = [id, name, institution_id, created_at, updated_at]
end
