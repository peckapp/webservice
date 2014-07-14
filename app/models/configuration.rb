class Configuration < ActiveRecord::Base
  include ModelNormalValidations
  include ModelBeforeSaveValidations
# verified

  ### Associations ###
  # each config is for just one institution
  has_one :institution #
  ####################

  ### Validations ###
  validates :config_file_name, :presence => true, :uniqueness => true
  validate :correct_configuration_types
  ###################

  ### Callbacks ###
  # before_save :sanitize_configuration
  # before_create :sanitize_configuration
  # before_update :sanitize_configuration
  #################

  ### Methods ###
  private
    def correct_configuration_types
        is_correct_type(mascot, String, "string", :mascot)
        is_correct_type(config_file_name, String, "string", :config_file_name)
    end
  #
  # def sanitize_configuration
  #   sanitize_everything(attributes)
  # end

  # private
  #   attributes = [id, mascot, config_file_name, created_at, updated_at]
end
