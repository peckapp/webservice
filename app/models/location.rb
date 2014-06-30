class Location < ActiveRecord::Base
# verified

  ### Validations ###
  # validates_presence_of :institution_id
  # validates_presence_of :name
  ###################

  ### Callbacks ###
  #################

  ### a location has just one institution ###
  belongs_to :institution
end
