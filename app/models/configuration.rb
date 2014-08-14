class Configuration < ActiveRecord::Base
  include ModelNormalValidations

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  # each config is for just one institution
  has_one :institution #

  ###############################
  ##                           ##
  ##        VALIDATIONS        ##
  ##                           ##
  ###############################

  validates :config_file_name, presence: true, uniqueness: true
  validate :correct_configuration_types

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  private
  def correct_configuration_types
    is_correct_type(mascot, String, 'string', :mascot)
    is_correct_type(config_file_name, String, 'string', :config_file_name)
  end
end
