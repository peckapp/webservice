class MenuItem < ActiveRecord::Base
# verified

  ### Validations ###
  # validates :name, :presence => true :uniqueness => true
  # validates_presence_of :institution_id
  # validates_presence_of :dining_place_id
  ###################

  ### Callbacks ###
  #################

  ### institution where item is available ###
  belongs_to :institution #

  ### dining place where item is available ###
  has_and_belongs_to_many :dining_places #

  ### menu item is available during these periods ###
  has_and_belongs_to_many :dining_periods #
end
