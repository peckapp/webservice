class DataResource < ActiveRecord::Base

  ###############################
  ##                           ##
  ##       ASSOCIATIONS        ##
  ##                           ##
  ###############################

  belongs_to :resource_type

  ### each selector has a DataResource that defines for which column that data applies in the given model
  has_many :selectors

  ###############################
  ##                           ##
  ##      HELPER METHODS       ##
  ##                           ##
  ###############################

  # model can be nil if it doesn't exist
  def model
    resource_type = ResourceType.find(resource_type_id)
    return resource_type.model
  end
end
