class MenuItem < ActiveRecord::Base
# verified

  ### Validations ###
  # validates :name, :presence => true
  # validates :institution_id, :presence => true
  # validates :dining_place_id, :numericality => true, :allow_nil => true
  #

  ###################

  ### Callbacks ###
  #################

  ### institution where item is available ###
  belongs_to :institution #

  ### dining place where item is available ###
  belongs_to :dining_place #

  ### dining opportunity when item is available ###
  belongs_to :dining_opportunity #
end
